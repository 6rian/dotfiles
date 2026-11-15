-- Tools for reviewing and pointing at code while a coding agent (Claude Code)
-- works in another tmux pane. Gitsigns base switching lives in
-- plugins/editor/gitsigns.lua; the format-on-save check lives in
-- plugins/formatting/conform.lua.

-- [[ Pick up files changed on disk (e.g. by an agent) ]]
-- `autoread` is on, but Neovim only notices external changes when something
-- runs :checktime. Unmodified buffers reload silently; modified ones warn.
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'TermLeave' }, {
  desc = 'Reload buffers changed outside Neovim',
  group = vim.api.nvim_create_augroup('agent-review-checktime', { clear = true }),
  callback = function()
    -- :checktime isn't allowed in the command-line window (E11)
    if vim.fn.getcmdwintype() == '' then
      vim.cmd 'checktime'
    end
  end,
})

-- [[ Point the agent at code ]]

--- Path of the current buffer relative to its git root, or to the cwd when
--- the file isn't in a git repo.
---@return string? relpath, string? abspath
local function buf_paths()
  local abs = vim.api.nvim_buf_get_name(0)
  if abs == '' then
    vim.notify('Buffer has no file name', vim.log.levels.WARN)
    return nil
  end
  abs = vim.fs.normalize(vim.fn.fnamemodify(abs, ':p'))
  local root = vim.fs.root(0, '.git')
  local rel = root and vim.fs.relpath(root, abs) or vim.fn.fnamemodify(abs, ':.')
  return rel, abs
end

--- Current line in normal mode, or the selected line range in visual mode.
--- Leaves visual mode.
---@return integer first, integer last
local function line_range()
  local a, b = vim.fn.line '.', vim.fn.line '.'
  local mode = vim.fn.mode()
  if mode == 'v' or mode == 'V' or mode == '\22' then
    a = vim.fn.line 'v'
    if a > b then
      a, b = b, a
    end
    vim.api.nvim_feedkeys(vim.keycode '<Esc>', 'nx', false)
  end
  return a, b
end

---@param first integer
---@param last integer
local function line_ref(first, last)
  if first == last then
    return '#L' .. first
  end
  return '#L' .. first .. '-L' .. last
end

local function yank(text, what)
  vim.fn.setreg('+', text)
  vim.notify('Yanked ' .. (what or text), vim.log.levels.INFO)
end

vim.keymap.set({ 'n', 'x' }, '<leader>yf', function()
  local rel = buf_paths()
  if rel then
    yank(rel .. line_ref(line_range()))
  end
end, { desc = 'Yank relative path#L<n>' })

vim.keymap.set('n', '<leader>yp', function()
  local _, abs = buf_paths()
  if abs then
    yank(abs)
  end
end, { desc = 'Yank absolute path' })

-- Filetypes whose usual code-fence tag differs from the filetype name
local fence_lang = {
  typescriptreact = 'tsx',
  javascriptreact = 'jsx',
  sh = 'bash',
}

vim.keymap.set('x', '<leader>cc', function()
  local rel = buf_paths()
  if not rel then
    return
  end
  local first, last = line_range()
  local ft = vim.bo.filetype
  local out = { rel .. line_ref(first, last), '```' .. (fence_lang[ft] or ft) }
  vim.list_extend(out, vim.api.nvim_buf_get_lines(0, first - 1, last, false))
  table.insert(out, '```')
  yank(table.concat(out, '\n') .. '\n', (last - first + 1) .. ' lines as a code block')
end, { desc = 'Copy selection as code block' })

-- Type `@path lines X-Y ` into the last-used tmux pane (the agent), without
-- pressing Enter, so the prompt can be finished there.
vim.keymap.set({ 'n', 'x' }, '<leader>ys', function()
  if not vim.env.TMUX then
    line_range() -- still leave visual mode
    vim.notify('Not inside tmux', vim.log.levels.WARN)
    return
  end
  local rel = buf_paths()
  if not rel then
    return
  end
  local first, last = line_range()
  local lines = first == last and ('line ' .. first) or ('lines ' .. first .. '-' .. last)
  local text = '@' .. rel .. ' ' .. lines .. ' '
  vim.system({ 'tmux', 'send-keys', '-t', '{last}', '-l', text }, { text = true }, function(res)
    vim.schedule(function()
      if res.code == 0 then
        vim.notify('Sent to last pane: ' .. text, vim.log.levels.INFO)
      else
        vim.notify('tmux send-keys failed: ' .. vim.trim(res.stderr or ''), vim.log.levels.ERROR)
      end
    end)
  end)
end, { desc = 'Send @path lines to last tmux pane' })

-- [[ Format-on-save toggles (read by conform's format_on_save) ]]
local ok, Snacks = pcall(require, 'snacks')
if ok then
  Snacks.toggle
    .new({
      id = 'autoformat_buffer',
      name = 'Format on Save (buffer)',
      get = function()
        return not vim.b.disable_autoformat
      end,
      set = function(state)
        vim.b.disable_autoformat = not state
      end,
    })
    :map '<leader>uf'
  Snacks.toggle
    .new({
      id = 'autoformat_global',
      name = 'Format on Save (global)',
      get = function()
        return not vim.g.disable_autoformat
      end,
      set = function(state)
        vim.g.disable_autoformat = not state
      end,
    })
    :map '<leader>uF'
end
