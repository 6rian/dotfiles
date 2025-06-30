return {
  'hachy/cmdpalette.nvim',
  config = function()
    require('cmdpalette').setup {
      win = {
        height = 0.3,
        width = 0.8,
        border = 'rounded',
        row_off = -2,
        -- Title requires nvim-0.9 or higher.
        title = 'Cmdpalette',
        title_pos = 'center',
      },
      sign = {
        text = ':',
      },
      buf = {
        filetype = 'vim',
        syntax = 'vim',
      },
      delete_confirm = true,
      show_title = true,
    }

    vim.keymap.set('n', ':', '<Plug>(cmdpalette)')
  end,
}
