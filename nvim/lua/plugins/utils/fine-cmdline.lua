return {
  'VonHeikemen/fine-cmdline.nvim',
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
  init = function()
    vim.keymap.set('n', ':', '<cmd>FineCmdline<CR>', { desc = 'Nvim Command Line', noremap = true })
  end,
}
