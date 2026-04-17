local M = {}

local SOURCE_EXTS = { 'ts', 'tsx', 'js', 'jsx' }
local TEST_KINDS = { 'test', 'spec' }

local function contains(tbl, value)
  for _, v in ipairs(tbl) do
    if v == value then
      return true
    end
  end
  return false
end

local function dedupe(paths)
  local seen = {}
  local out = {}

  for _, path in ipairs(paths) do
    if path and path ~= '' and not seen[path] then
      seen[path] = true
      table.insert(out, path)
    end
  end

  return out
end

local function path_join(...)
  local parts = {}
  for _, part in ipairs { ... } do
    if part and part ~= '' and part ~= '.' then
      table.insert(parts, part)
    end
  end

  if #parts == 0 then
    return '.'
  end

  return table.concat(parts, '/')
end

local function normalize(path)
  return vim.fs.normalize(path)
end

local function file_exists(path)
  return vim.uv.fs_stat(path) ~= nil
end

local function open_file(path)
  vim.cmd.edit(vim.fn.fnameescape(path))
end

local function split_name(name)
  for _, kind in ipairs(TEST_KINDS) do
    local base, ext = name:match('^(.*)%.' .. kind .. '%.([^.]+)$')
    if base and ext and contains(SOURCE_EXTS, ext) then
      return {
        base = base,
        kind = kind,
        ext = ext,
        is_test = true,
      }
    end
  end

  local base, ext = name:match '^(.*)%.([^.]+)$'
  if base and ext and contains(SOURCE_EXTS, ext) then
    return {
      base = base,
      kind = nil,
      ext = ext,
      is_test = false,
    }
  end

  return nil
end

local function get_root()
  return vim.fs.root(0, { '.git', 'package.json', 'tsconfig.json', 'jsconfig.json' }) or vim.fn.getcwd()
end

local function add_match(matches, path, current_file)
  if not path or path == '' then
    return
  end

  local normalized = normalize(path)
  if normalized ~= current_file and file_exists(normalized) then
    table.insert(matches, normalized)
  end
end

local function build_direct_candidates(info, rel_dir)
  local candidates = {}

  if info.is_test then
    -- foo.test.ts -> foo.ts / foo.tsx / foo.js / foo.jsx
    for _, ext in ipairs(SOURCE_EXTS) do
      table.insert(candidates, path_join(rel_dir, info.base .. '.' .. ext))
    end

    -- dir/__tests__/foo.test.ts -> dir/foo.ts etc
    local parent_dir = rel_dir:gsub('/__tests__$', '')
    if parent_dir ~= rel_dir then
      for _, ext in ipairs(SOURCE_EXTS) do
        table.insert(candidates, path_join(parent_dir, info.base .. '.' .. ext))
      end
    end
  else
    -- foo.ts -> foo.test.ts / foo.spec.ts, plus __tests__ variants
    for _, kind in ipairs(TEST_KINDS) do
      for _, ext in ipairs(SOURCE_EXTS) do
        table.insert(candidates, path_join(rel_dir, info.base .. '.' .. kind .. '.' .. ext))
        table.insert(candidates, path_join(rel_dir, '__tests__', info.base .. '.' .. kind .. '.' .. ext))
      end
    end
  end

  return dedupe(candidates)
end

local function find_project_wide_matches(info, root, current_file)
  local matches = {}

  if vim.fn.executable 'fd' == 1 then
    local patterns = {}

    if info.is_test then
      for _, ext in ipairs(SOURCE_EXTS) do
        table.insert(patterns, info.base .. '.' .. ext)
      end
    else
      for _, kind in ipairs(TEST_KINDS) do
        for _, ext in ipairs(SOURCE_EXTS) do
          table.insert(patterns, info.base .. '.' .. kind .. '.' .. ext)
        end
      end
    end

    for _, pattern in ipairs(patterns) do
      local result = vim.system({ 'fd', '-p', '-a', pattern, root }, { text = true }):wait()
      if result.code == 0 and result.stdout then
        for line in result.stdout:gmatch '[^\r\n]+' do
          add_match(matches, line, current_file)
        end
      end
    end
  elseif vim.fn.executable 'rg' == 1 then
    local result = vim.system({ 'rg', '--files', root }, { text = true }):wait()

    if result.code == 0 and result.stdout then
      for line in result.stdout:gmatch '[^\r\n]+' do
        local base = vim.fs.basename(line)

        if info.is_test then
          for _, ext in ipairs(SOURCE_EXTS) do
            if base == (info.base .. '.' .. ext) then
              add_match(matches, path_join(root, line), current_file)
              break
            end
          end
        else
          local matched = false
          for _, kind in ipairs(TEST_KINDS) do
            for _, ext in ipairs(SOURCE_EXTS) do
              if base == (info.base .. '.' .. kind .. '.' .. ext) then
                add_match(matches, path_join(root, line), current_file)
                matched = true
                break
              end
            end
            if matched then
              break
            end
          end
        end
      end
    end
  else
    local found = vim.fs.find(function(name, path)
      local full = normalize(path_join(path, name))
      if not file_exists(full) or full == current_file then
        return false
      end

      if info.is_test then
        for _, ext in ipairs(SOURCE_EXTS) do
          if name == (info.base .. '.' .. ext) then
            return true
          end
        end
        return false
      end

      for _, kind in ipairs(TEST_KINDS) do
        for _, ext in ipairs(SOURCE_EXTS) do
          if name == (info.base .. '.' .. kind .. '.' .. ext) then
            return true
          end
        end
      end

      return false
    end, {
      path = root,
      type = 'file',
      limit = math.huge,
    })

    for _, path in ipairs(found) do
      add_match(matches, path, current_file)
    end
  end

  return dedupe(matches)
end

local function sort_matches(matches, root, rel_dir, info)
  local current_abs_dir = normalize(path_join(root, rel_dir))
  local source_dir_from_test = rel_dir:gsub('/__tests__$', '')

  local function score(path)
    local s = 0
    local dir = normalize(vim.fs.dirname(path))

    if dir == current_abs_dir then
      s = s + 10
    end

    if path:match '/__tests__/' then
      s = s + 5
    end

    if info.is_test then
      local sibling_dir = normalize(path_join(root, source_dir_from_test))
      if dir == sibling_dir then
        s = s + 8
      end
    end

    if not info.is_test then
      local candidate_info = split_name(vim.fs.basename(path))
      if candidate_info and candidate_info.is_test then
        s = s + 2
      end
    end

    return s
  end

  table.sort(matches, function(a, b)
    local sa = score(a)
    local sb = score(b)

    if sa == sb then
      return a < b
    end

    return sa > sb
  end)
end

function M.toggle()
  local current_file = vim.api.nvim_buf_get_name(0)
  if current_file == '' then
    vim.notify('No file in current buffer', vim.log.levels.ERROR, { title = 'Tests' })
    return
  end

  current_file = normalize(current_file)

  local root = get_root()
  local rel_path = vim.fs.relpath(root, current_file)

  if not rel_path then
    vim.notify('Current file is not inside the project root', vim.log.levels.ERROR, { title = 'Tests' })
    return
  end

  local rel_dir = vim.fs.dirname(rel_path)
  local filename = vim.fs.basename(rel_path)

  local info = split_name(filename)
  if not info then
    vim.notify('Current file is not a supported source/test file: ' .. filename, vim.log.levels.ERROR, { title = 'Tests' })
    return
  end

  -- Fast path: explicit nearby candidates.
  local direct_candidates = build_direct_candidates(info, rel_dir)

  for _, rel_candidate in ipairs(direct_candidates) do
    local abs_candidate = normalize(path_join(root, rel_candidate))
    if abs_candidate ~= current_file and file_exists(abs_candidate) then
      open_file(abs_candidate)
      return
    end
  end

  -- Slow path: search the project.
  local matches = find_project_wide_matches(info, root, current_file)

  if #matches == 0 then
    local target = info.is_test and 'source' or 'test/spec'
    vim.notify('No corresponding ' .. target .. ' file found for ' .. filename, vim.log.levels.ERROR, { title = 'Tests' })
    return
  end

  sort_matches(matches, root, rel_dir, info)

  if #matches == 1 then
    open_file(matches[1])
    return
  end

  vim.ui.select(matches, {
    prompt = 'Select matching ' .. (info.is_test and 'source' or 'test/spec') .. ' file:',
    format_item = function(item)
      return vim.fs.relpath(root, item) or item
    end,
  }, function(choice)
    if choice then
      open_file(choice)
    end
  end)
end

return M
