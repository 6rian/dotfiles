return {
  'kyzabuilds/xeno.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    local xeno = require 'xeno'

    -- xeno.color('red', '#ff6b76')
    -- xeno.color('amber', '#ffbd6e')
    -- xeno.color('green', '#7ee495')

    xeno.color('green', '#a6e12d')
    xeno.color('indigo', '#7c83fd')
    -- xeno.color('magenta', '#F11FCB')
    xeno.color('magenta', '#FF237D')
    xeno.color('cyan', '#00d7ff')

    -- xeno.theme() (unlike xeno.setup()) writes colors/xeno-cyberpunk-v2.lua
    -- into stdpath('config'), which is what makes it discoverable via
    -- `:colorscheme` completion and colorscheme pickers.
    xeno.theme('xeno-cyberpunk-v2', {
      -- background = '#0b0d10',
      background = '#0B041A',
      foreground = '#eef1f0',
      accent = '#6C23FF',

      -- transparent = true here: xeno only exposes an on/off `transparent` flag
      -- (it sets Normal/NormalNC/SignColumn/EndOfBuffer bg to NONE) — there's no
      -- numeric alpha in the colorscheme itself. The 0.8 opacity comes from the
      -- terminal (kitty.conf already has background_opacity 0.8).
      transparent = true,

      properties = {
        contrast = 0.15,
        variation = 0.2,
        chroma = 0.5,
        lightness = 0,
      },

      min_contrast = 4.5,

      highlights = {
        editor = {
          Normal = { fg = '@foreground.100', bg = '@background.950' },
          LineNr = { fg = '@background.500' },
          CursorLineNr = { fg = '@accent' },
          CursorLine = { bg = xeno.opaque('@foreground.50', 0.05) },
          Visual = { bg = xeno.opaque('@accent.500', 0.2) },
          Search = { bg = xeno.opaque('@cyan.500', 0.3) },
          IncSearch = { bg = xeno.opaque('@cyan.500', 0.5) },
          Pmenu = { bg = '@background.800', fg = '@foreground.200' },
          PmenuSel = { bg = xeno.opaque('@accent.500', 0.25) },
          Directory = { fg = '@cyan.300' },
          ErrorMsg = { fg = '@magenta.400' },
          WarningMsg = { fg = '@accent' },
        },
        syntax = {
          ['@comment'] = { fg = '@background.500', italic = true },
          ['@string'] = { fg = '@green.200' },
          ['@number'] = { fg = '@cyan.300' },
          ['@boolean'] = { fg = '@cyan.400' },
          ['@keyword'] = { fg = '@indigo.400', bold = true },
          ['@function'] = { fg = '@accent' },
          ['@function.builtin'] = { fg = '@accent' },
          ['@variable'] = { fg = '@foreground.200' },
          ['@variable.builtin'] = { fg = '@magenta.300' },
          ['@type'] = { fg = '@indigo.300' },
          ['@constant'] = { fg = '@cyan.300' },
          ['@property'] = { fg = '@foreground.300' },
          ['@punctuation'] = { fg = '@background.500' },
          ['@tag'] = { fg = '@magenta.300' },
          Type = { link = '@type' },
        },
        plugins = {
          GitSignsAdd = { fg = '@green.600' },
          GitSignsChange = { fg = '@accent' },
          GitSignsDelete = { fg = '@magenta.400' },
          TelescopeSelection = { bg = xeno.opaque('@accent.500', 0.15) },
          TelescopeMatching = { fg = '@indigo.300', bold = true },
        },
      },
    })

    vim.cmd 'colorscheme xeno-cyberpunk-v2'
  end,
}
