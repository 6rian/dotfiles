return {
  {
    'maxmx03/fluoromachine.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      local fm = require 'fluoromachine'

      function overrides(c, color)
        -- local darken = color.darken
        -- local lighten = color.lighten
        -- local blend = color.blend
        -- local shade = color.shade
        -- local tint = color.tint
        return {
          -- LSP
          String = { fg = '#ffffff' },
          ['@lsp.type.parameter'] = { fg = '#a6e12d' },
          ['@variable.parameter'] = { fg = '#a6e12d' },

          -- Snacks.nvim
          NormalFloat = { fg = '#ffffff', bg = 'NONE' },

          -- Telescope
          TelescopeNormal = { fg = '#ffffff', bg = 'NONE' },
          -- TelescopeResultsBorder = { fg = c.purple, bg = 'NONE' },
          TelescopeResultsNormal = { fg = '#ffffff', bg = 'NONE' },
          -- TelescopePreviewNormal = { bg = c.bg },
          -- TelescopePromptBorder = { fg = c.bgdark, bg = c.bgdark },
          -- TelescopeTitle = { fg = c.red, bg = shade(c.red, 5) },
          -- TelescopePromptPrefix = { fg = c.purple },
        }
      end

      fm.setup {
        glow = true,
        theme = 'fluoromachine', -- 'fluoromachine', 'delta', 'retrowave'
        transparent = true,
        overrides = overrides,
      }

      vim.cmd.colorscheme 'fluoromachine'
    end,
  },
}
