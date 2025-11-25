return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  after = 'catppuccin',
  config = function()
    -- These colors from from the overrides in my catppuccin config
    local colors = {
      rosewater = '#F5B8AB',
      flamingo = '#F29D9D',
      pink = '#AD6FF7',
      mauve = '#FF8F40',
      red = '#E66767',
      maroon = '#EB788B',
      peach = '#FAB770',
      yellow = '#FACA64',
      green = '#70CF67',
      teal = '#4CD4BD',
      sky = '#61BDFF',
      sapphire = '#4BA8FA',
      blue = '#00BFFF',
      lavender = '#00BBCC',
      text = '#C1C9E6',
      subtext1 = '#A3AAC2',
      subtext0 = '#8E94AB',
      overlay2 = '#7D8296',
      overlay1 = '#676B80',
      overlay0 = '#464957',
      surface2 = '#3A3D4A',
      surface1 = '#2F313D',
      surface0 = '#1D1E29',
      base = '#0b0b12',
      mantle = '#11111a',
      crust = '#191926',
    }

    require('bufferline').setup {
      options = {
        indicator = {
          style = 'underline',
        },
        offsets = {
          {
            filetype = 'neo-tree',
            text = 'FILE EXPLORER',
            highlight = 'Directory',
            separator = true, -- use a "true" to enable the default, or set your own character
          },
        },
        tab_size = 18,
        separator_style = 'slope',
        show_buffer_close_icons = false,
        show_tab_indicators = true,
      },
    }

    vim.keymap.set('n', '<space>bn', '<cmd>BufferLineCycleNext<CR>', { desc = 'Next Buffer', noremap = true })
    vim.keymap.set('n', '<space>bp', '<cmd>BufferLineCyclePrev<CR>', { desc = 'Previous Buffer', noremap = true })
    vim.keymap.set('n', '<space>bco', '<cmd>BufferLineCloseOthers<CR>', { desc = 'Close Other Buffers', noremap = true })
    vim.keymap.set('n', '<space>bcl', '<cmd>BufferLineCloseLeft<CR>', { desc = 'Close Left', noremap = true })
    vim.keymap.set('n', '<space>bcr', '<cmd>BufferLineCloseRight<CR>', { desc = 'Close Right', noremap = true })
    vim.keymap.set('n', '<space>btp', '<cmd>BufferLineTogglePin<CR>', { desc = 'Toggle Pin', noremap = true })
  end,
}
