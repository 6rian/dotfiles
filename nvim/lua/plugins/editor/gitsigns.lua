-- Adds git related signs to the gutter, as well as utilities for managing changes
-- What to review the current worktree against: the merge-base of HEAD and the
-- base branch (origin/HEAD, else main, else master), so commits that landed on
-- the base branch after the agent branched don't show up as reversed hunks.
-- Returns the branch name and the merge-base commit. Runs from the buffer's
-- directory so worktrees resolve correctly.
local function detect_base(bufnr)
  local dir = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
  local function git(args)
    local res = vim.system(vim.list_extend({ 'git' }, args), { cwd = dir, text = true }):wait()
    return res.code == 0 and vim.trim(res.stdout) or nil
  end
  local branch = git { 'symbolic-ref', '--quiet', '--short', 'refs/remotes/origin/HEAD' }
  if not branch or branch == '' then
    branch = nil
    for _, b in ipairs { 'main', 'master' } do
      if git { 'rev-parse', '--verify', '--quiet', 'refs/heads/' .. b } then
        branch = b
        break
      end
    end
  end
  if not branch then
    return nil
  end
  return branch, git { 'merge-base', 'HEAD', branch }
end

return {
  'lewis6991/gitsigns.nvim',
  config = function()
    require('gitsigns').setup {
      signs = {
        add = { text = '' },
        change = { text = '' },
        delete = { text = '' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Go to next hunk' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Go to previous hunk' })

        -- Actions
        map('n', '<leader>ghs', gitsigns.stage_hunk, { desc = 'Stage hunk' })
        map('n', '<leader>ghr', gitsigns.reset_hunk, { desc = 'Reset hunk' })

        map('v', '<leader>ghs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'Stage hunk (visual)' })

        map('v', '<leader>ghr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'Reset hunk (visual)' })

        map('n', '<leader>gS', gitsigns.stage_buffer, { desc = 'Stage buffer' })
        map('n', '<leader>gR', gitsigns.reset_buffer, { desc = 'Reset buffer' })
        -- map('n', '<leader>gp', gitsigns.preview_hunk, { desc = 'Preview hunk' })
        map('n', '<leader>ghp', gitsigns.preview_hunk_inline, { desc = 'Preview hunk inline' })

        map('n', '<leader>ghb', function()
          gitsigns.blame_line { full = true }
        end, { desc = 'Blame line' })

        -- map('n', '<leader>ghd', gitsigns.diffthis, { desc = 'Diff this' })

        -- map('n', '<leader>ghD', function()
        --   gitsigns.diffthis '~'
        -- end, { desc = 'Diff this against previous commit' })

        map('n', '<leader>ghQ', function()
          gitsigns.setqflist 'all'
        end, { desc = 'Set qflist (all hunks)' })
        map('n', '<leader>ghq', gitsigns.setqflist, { desc = 'Set qflist (buffer hunks)' })

        -- Review against the base branch (e.g. an agent's worktree vs main).
        -- `true` applies it to every buffer, and setqflist above follows it.
        map('n', '<leader>ghc', function()
          local branch, merge_base = detect_base(bufnr)
          if not branch then
            vim.notify('No base branch found (origin/HEAD, main, master)', vim.log.levels.WARN)
            return
          end
          if not merge_base then
            vim.notify('No merge-base with ' .. branch, vim.log.levels.WARN)
            return
          end
          gitsigns.change_base(merge_base, true)
          vim.notify(('Gitsigns base: merge-base with %s (%s)'):format(branch, merge_base:sub(1, 7)), vim.log.levels.INFO)
        end, { desc = 'Diff against base branch (merge-base)' })
        map('n', '<leader>ghC', function()
          gitsigns.reset_base(true)
          vim.notify('Gitsigns base: index', vim.log.levels.INFO)
        end, { desc = 'Reset base to index' })

        -- Toggles
        map('n', '<leader>gtb', gitsigns.toggle_current_line_blame, { desc = 'Toggle current line blame' })
        map('n', '<leader>ghw', gitsigns.toggle_word_diff, { desc = 'Toggle word diff' })

        -- Text object
        map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, { desc = 'Select hunk' })
      end,
    }
  end,
}
