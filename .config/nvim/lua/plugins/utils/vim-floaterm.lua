return {
  'voldikss/vim-floaterm',
  config = function()
    -- Normal mode keymap
    vim.keymap.set('n', 'to', '<cmd>FloatermNew<CR>', { desc = 'Open New Floaterm', noremap = true })
    vim.keymap.set('n', 'tt', '<cmd>FloatermToggle<CR>', { desc = 'Toggle Floaterm', noremap = true })
    vim.keymap.set('n', 'tp', '<cmd>FloatermPrev<CR>', { desc = 'Previous Floaterm', noremap = true })
    vim.keymap.set('n', 'tn', '<cmd>FloatermNext<CR>', { desc = 'Next Floaterm', noremap = true })
    vim.keymap.set('n', 'tk', '<cmd>FloatermKill<CR>', { desc = 'Kill Floaterm', noremap = true })

    -- NOTE: highlight group settings are in catppuccin config
  end,
}
