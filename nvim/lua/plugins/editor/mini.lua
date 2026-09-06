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
    require('mini.icons').setup()
    require('mini.move').setup()
    require('mini.operators').setup()

    -- Pending-keybind popup (replaces which-key.nvim)
    local miniclue = require 'mini.clue'
    miniclue.setup {
      triggers = {
        { mode = 'n', keys = '<Leader>' },
        { mode = 'x', keys = '<Leader>' },

        { mode = 'n', keys = 'g' },
        { mode = 'x', keys = 'g' },

        { mode = 'n', keys = 'z' },
        { mode = 'x', keys = 'z' },

        { mode = 'i', keys = '<C-x>' },

        { mode = 'n', keys = "'" },
        { mode = 'x', keys = "'" },
        { mode = 'n', keys = '`' },
        { mode = 'x', keys = '`' },

        { mode = 'n', keys = '"' },
        { mode = 'x', keys = '"' },
        { mode = 'i', keys = '<C-r>' },
        { mode = 'c', keys = '<C-r>' },

        { mode = 'n', keys = '<C-w>' },
      },
      clues = {
        { mode = 'n', keys = '<Leader>c', desc = '+Code' },
        { mode = 'x', keys = '<Leader>c', desc = '+Code' },
        { mode = 'n', keys = '<Leader>d', desc = '+Document' },
        { mode = 'n', keys = '<Leader>r', desc = '+Rename' },
        { mode = 'n', keys = '<Leader>s', desc = '+Search' },
        { mode = 'n', keys = '<Leader>w', desc = '+Workspace' },
        { mode = 'n', keys = '<Leader>t', desc = '+Toggle' },
        { mode = 'n', keys = '<Leader>h', desc = '+Git Hunk' },
        { mode = 'x', keys = '<Leader>h', desc = '+Git Hunk' },

        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.z(),
      },
      window = {
        delay = 100,
        -- Full width, anchored bottom-left, a bit taller than the auto-fit default
        config = function()
          return {
            width = vim.o.columns - 2,
            height = math.floor(vim.o.lines * 0.4),
            anchor = 'SW',
            col = 0,
          }
        end,
      },
    }
    require('mini.splitjoin').setup {
      mappings = {
        toggle = 'gst',
        split = 'gsp',
        join = 'gsj',
      },
    }

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

    -- require('mini.tabline').setup()

    -- ... and there is more!
    --  Check out: https://github.com/echasnovski/mini.nvim
  end,
}
