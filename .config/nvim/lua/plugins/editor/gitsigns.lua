-- Adds git related signs to the gutter, as well as utilities for managing changes
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
        map('n', '<leader>gp', gitsigns.preview_hunk, { desc = 'Preview hunk' })
        map('n', '<leader>gi', gitsigns.preview_hunk_inline, { desc = 'Preview hunk inline' })

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

        -- Toggles
        map('n', '<leader>gtb', gitsigns.toggle_current_line_blame, { desc = 'Toggle current line blame' })

        -- Text object
        map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, { desc = 'Select hunk' })
      end,
    }
  end,
}
