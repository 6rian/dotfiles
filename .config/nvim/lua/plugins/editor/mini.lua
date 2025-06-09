-- Collection of various small independent plugins/modules
return {
  'echasnovski/mini.nvim',
  version = '*',
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }

    -- require('mini.base16').setup {
    --   palette = {
    --     base00 = '#112641',
    --     base01 = '#3a475e',
    --     base02 = '#606b81',
    --     base03 = '#8691a7',
    --     base04 = '#d5dc81',
    --     base05 = '#e2e98f',
    --     base06 = '#eff69c',
    --     base07 = '#fcffaa',
    --     base08 = '#ffcfa0',
    --     base09 = '#cc7e46',
    --     base0A = '#46a436',
    --     base0B = '#9ff895',
    --     base0C = '#ca6ecf',
    --     base0D = '#42f7ff',
    --     base0E = '#ffc4ff',
    --     base0F = '#00a5c5',
    --   },
    --   use_cterm = true,
    --   plugins = {
    --     default = false,
    --     ['echasnovski/mini.nvim'] = true,
    --   },
    -- }

    require('mini.bracketed').setup()
    require('mini.colors').setup()
    require('mini.move').setup()
    require('mini.operators').setup()
    require('mini.splitjoin').setup()

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup()

    -- Simple and easy statusline.
    --  You could remove this setup call if you don't like it,
    --  and try some other statusline plugin
    local statusline = require 'mini.statusline'
    -- set use_icons to true if you have a Nerd Font
    statusline.setup { use_icons = vim.g.have_nerd_font }

    -- You can configure sections in the statusline by overriding their
    -- default behavior. For example, here we set the section for
    -- cursor location to LINE:COLUMN
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
      return '%2l:%-2v'
    end

    -- ... and there is more!
    --  Check out: https://github.com/echasnovski/mini.nvim
  end,
}
