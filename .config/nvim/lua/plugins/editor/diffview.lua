-- Side-by-side diff viewing: uncommitted changes and branch-vs-base comparisons
return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewToggleFiles', 'DiffviewFocusFiles', 'DiffviewFileHistory' },
  keys = {
    { '<leader>gdo', '<cmd>DiffviewOpen<CR>', desc = 'Diff: uncommitted changes' },
    { '<leader>gdc', '<cmd>DiffviewClose<CR>', desc = 'Diff: close' },
    {
      '<leader>gdb',
      function()
        vim.ui.input({ prompt = 'Diff current branch against: ', default = 'main' }, function(base)
          if base and base ~= '' then
            vim.cmd('DiffviewOpen ' .. base .. '...HEAD')
          end
        end)
      end,
      desc = 'Diff: branch against base',
    },
    { '<leader>gdh', '<cmd>DiffviewFileHistory %<CR>', desc = 'Diff: current file history' },
    { '<leader>gdH', '<cmd>DiffviewFileHistory<CR>', desc = 'Diff: repo history' },
  },
  opts = {},
}
