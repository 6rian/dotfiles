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

    -- v3 palette: Tailwind CSS v4's default orange/cyan/blue/purple/pink
    -- scales (given as oklch(L C H) triples). Converted to hex with the
    -- canonical OKLCH->sRGB matrices rather than xeno.color2hex/oklch2hex --
    -- xeno.nvim's own OKLCH<->hex math uses non-standard matrix constants
    -- (self-consistent for its own hex-in/hex-out round trips, but it turns
    -- standard CSS oklch() hues like blue's ~260deg into something that
    -- renders teal). Representative -500 shade used as the seed for each
    -- named scale; -600 for purple/accent, which is the more saturated,
    -- brand-appropriate step of that particular family.
    xeno.color('cyberOrange', '#ff6900') -- orange-500
    xeno.color('cyberCyan', '#00b8db') -- cyan-500
    xeno.color('cyberBlue', '#2b7fff') -- blue-500
    xeno.color('cyberPink', '#f6339a') -- pink-500

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

      -- ghostty/themes/xeno-cyberpunk-v2 is now a real, static Ghostty theme
      -- (see the dotfiles repo) -- disable xeno.nvim's own redundant
      -- ghostty/config auto-write (its default is update_config = true),
      -- which would otherwise re-clobber that clean setup every time nvim
      -- runs inside a Ghostty window.
      integrations = {
        ghostty = { update_config = false },
      },

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

          -- Diffview: mirror the GitSigns add/change/delete palette
          DiffviewPrimary = { fg = '@accent' },
          DiffviewSecondary = { fg = '@indigo.300' },
          DiffviewDim1 = { fg = '@background.500' },

          DiffviewFilePanelTitle = { fg = '@accent', bold = true },
          DiffviewFilePanelCounter = { fg = '@indigo.400', bold = true },
          DiffviewFilePanelFileName = { fg = '@foreground.200' },
          DiffviewFilePanelPath = { fg = '@background.500' },
          DiffviewFilePanelInsertions = { fg = '@green.600' },
          DiffviewFilePanelDeletions = { fg = '@magenta.400' },
          DiffviewFilePanelSelected = { fg = '@accent', bold = true },

          DiffviewStatusAdded = { fg = '@green.600' },
          DiffviewStatusUntracked = { fg = '@green.400' },
          DiffviewStatusModified = { fg = '@accent' },
          DiffviewStatusRenamed = { fg = '@cyan.300' },
          DiffviewStatusCopied = { fg = '@cyan.300' },
          DiffviewStatusTypeChange = { fg = '@indigo.300' },
          DiffviewStatusTypeChanged = { fg = '@indigo.300' },
          DiffviewStatusUnmerged = { fg = '@magenta.300' },
          DiffviewStatusUnknown = { fg = '@background.500' },
          DiffviewStatusDeleted = { fg = '@magenta.400' },
          DiffviewStatusBroken = { fg = '@magenta.400' },
          DiffviewStatusIgnored = { fg = '@background.500', italic = true },

          DiffviewFolderSign = { fg = '@cyan.300' },
          DiffviewFolderName = { fg = '@cyan.300' },

          DiffviewReference = { fg = '@cyan.300' },
          DiffviewHash = { fg = '@background.500', italic = true },
        },
      },
    })

    -- Light variant: same accent/custom-color seeds as the dark theme above,
    -- but a muted purple-gray background instead of near-black. No
    -- ghostty/kitty integration yet -- that's a follow-up once the palette
    -- itself looks right in nvim. Preview it with `:colorscheme xeno-light-v1`.
    xeno.theme('xeno-light-v1', {
      background = '#8B8494',
      foreground = '#241B33',
      accent = '#6C23FF',

      transparent = false,

      properties = {
        -- Negative contrast pulls xeno's background_500..950 scale in toward
        -- its own midpoint instead of stretching it, so the level the theme
        -- uses everywhere for "canvas" surfaces (Normal, StatusLine, TabLine,
        -- NormalFloat -- which Snacks' explorer/picker link to) lands as a
        -- muted light purple-gray instead of near-white. Deliberately NOT
        -- overriding individual highlight groups: xeno's defaults already
        -- wire all of those surfaces to consistent, mutually-coherent levels
        -- of this one scale -- overriding just one of them (as a first pass
        -- here did to Normal) desyncs it from the rest and is what produced
        -- jarring white statusline/gutter/picker surfaces next to a custom
        -- background. Foreground gets the opposite (positive) contrast pull
        -- automatically, so text stays crisp while the canvas mutes down.
        contrast = -0.7,
        variation = 0.2,
        chroma = 0.5,
        lightness = 0,
      },

      min_contrast = 4.5,

      integrations = {
        ghostty = { update_config = false },
      },

      highlights = {
        editor = {
          CursorLineNr = { fg = '@accent' },
          CursorLine = { bg = xeno.opaque('@foreground.50', 0.05) },
          Visual = { bg = xeno.opaque('@accent.500', 0.2) },
          Search = { bg = xeno.opaque('@cyan.500', 0.3) },
          IncSearch = { bg = xeno.opaque('@cyan.500', 0.5) },
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

          DiffviewPrimary = { fg = '@accent' },
          DiffviewSecondary = { fg = '@indigo.300' },
          DiffviewDim1 = { fg = '@background.500' },

          DiffviewFilePanelTitle = { fg = '@accent', bold = true },
          DiffviewFilePanelCounter = { fg = '@indigo.400', bold = true },
          DiffviewFilePanelFileName = { fg = '@foreground.200' },
          DiffviewFilePanelPath = { fg = '@background.500' },
          DiffviewFilePanelInsertions = { fg = '@green.600' },
          DiffviewFilePanelDeletions = { fg = '@magenta.400' },
          DiffviewFilePanelSelected = { fg = '@accent', bold = true },

          DiffviewStatusAdded = { fg = '@green.600' },
          DiffviewStatusUntracked = { fg = '@green.400' },
          DiffviewStatusModified = { fg = '@accent' },
          DiffviewStatusRenamed = { fg = '@cyan.300' },
          DiffviewStatusCopied = { fg = '@cyan.300' },
          DiffviewStatusTypeChange = { fg = '@indigo.300' },
          DiffviewStatusTypeChanged = { fg = '@indigo.300' },
          DiffviewStatusUnmerged = { fg = '@magenta.300' },
          DiffviewStatusUnknown = { fg = '@background.500' },
          DiffviewStatusDeleted = { fg = '@magenta.400' },
          DiffviewStatusBroken = { fg = '@magenta.400' },
          DiffviewStatusIgnored = { fg = '@background.500', italic = true },

          DiffviewFolderSign = { fg = '@cyan.300' },
          DiffviewFolderName = { fg = '@cyan.300' },

          DiffviewReference = { fg = '@cyan.300' },
          DiffviewHash = { fg = '@background.500', italic = true },
        },
      },
    })

    -- v3 dark: same shape as xeno-cyberpunk-v2 above (background.950 canvas,
    -- transparent for the terminal's own opacity), but built entirely from
    -- the Tailwind v4 orange/cyan/blue/purple/pink scale instead of the
    -- original hand-picked hues. Purple-600 is the accent; the other four
    -- take over the old green/indigo/magenta/cyan syntax roles.
    xeno.theme('xeno-cyberpunk-v3-dark', {
      -- purple-950's hue at a much lower chroma (0.03 vs purple-950's 0.149).
      -- The raw swatch reads fine at canvas lightness (900/950 are dark enough
      -- to tame it) but @comment/@punctuation/LineNr all key off
      -- background_500 -- a mid-lightness level where that much chroma peaks
      -- into a vivid violet as loud as the accent, undermining the
      -- de-emphasis those groups are supposed to convey. Desaturating keeps
      -- the same purple identity (matches v2's near-black '#0B041A', which is
      -- similarly low-chroma) without that clash.
      background = '#2e2838',
      foreground = '#f3e8ff', -- purple-100
      accent = '#9810fa', -- purple-600

      transparent = true,

      properties = {
        contrast = -0.15,
        variation = 0.2,
        chroma = 0.5,
        lightness = 0,
      },

      min_contrast = 4.5,

      integrations = {
        ghostty = { update_config = false },
      },

      highlights = {
        editor = {
          Normal = { fg = '@foreground.100', bg = '@background.950' },
          LineNr = { fg = '@background.500' },
          CursorLineNr = { fg = '@accent' },
          CursorLine = { bg = xeno.opaque('@foreground.50', 0.05) },
          Visual = { bg = xeno.opaque('@accent.500', 0.2) },
          Search = { bg = xeno.opaque('@cyberCyan.500', 0.3) },
          IncSearch = { bg = xeno.opaque('@cyberCyan.500', 0.5) },
          Pmenu = { bg = '@background.800', fg = '@foreground.200' },
          PmenuSel = { bg = xeno.opaque('@accent.500', 0.25) },
          Directory = { fg = '@cyberCyan.200' },
          ErrorMsg = { fg = '@cyberPink.400' },
          WarningMsg = { fg = '@cyberOrange.400' },
        },
        syntax = {
          ['@comment'] = { fg = '@background.500', italic = true },
          -- Orange's in-gamut chroma ceiling drops off hard past ~L=.7 (dark
          -- scale) / ~L=.46 (light-variant override band) -- level .200 sits
          -- in a pale-salmon dead zone for this hue specifically (fine for
          -- green/blue/pink at that same level, just not orange). .300 is
          -- near max-vivid for orange in both variants; cyan bumped a level
          -- too for the same reason. This mismatch -- not the chroma property,
          -- which was already gamut-clipped -- was the main source of the
          -- "flat" feel vs v2 (green's ceiling stays high at .200, so v2
          -- never hit it).
          ['@string'] = { fg = '@cyberOrange.300' },
          ['@number'] = { fg = '@cyberCyan.200' },
          ['@boolean'] = { fg = '@cyberCyan.300' },
          ['@keyword'] = { fg = '@cyberBlue.400', bold = true },
          ['@function'] = { fg = '@accent' },
          ['@function.builtin'] = { fg = '@accent' },
          ['@variable'] = { fg = '@foreground.200' },
          ['@variable.builtin'] = { fg = '@cyberPink.300' },
          ['@type'] = { fg = '@cyberBlue.300' },
          ['@constant'] = { fg = '@cyberCyan.200' },
          ['@property'] = { fg = '@foreground.300' },
          ['@punctuation'] = { fg = '@background.500' },
          ['@tag'] = { fg = '@cyberPink.300' },
          Type = { link = '@type' },
        },
        plugins = {
          GitSignsAdd = { fg = '@cyberCyan.600' },
          GitSignsChange = { fg = '@accent' },
          GitSignsDelete = { fg = '@cyberPink.400' },
          TelescopeSelection = { bg = xeno.opaque('@accent.500', 0.15) },
          TelescopeMatching = { fg = '@cyberBlue.300', bold = true },

          DiffviewPrimary = { fg = '@accent' },
          DiffviewSecondary = { fg = '@cyberBlue.300' },
          DiffviewDim1 = { fg = '@background.500' },

          DiffviewFilePanelTitle = { fg = '@accent', bold = true },
          DiffviewFilePanelCounter = { fg = '@cyberBlue.400', bold = true },
          DiffviewFilePanelFileName = { fg = '@foreground.200' },
          DiffviewFilePanelPath = { fg = '@background.500' },
          DiffviewFilePanelInsertions = { fg = '@cyberCyan.600' },
          DiffviewFilePanelDeletions = { fg = '@cyberPink.400' },
          DiffviewFilePanelSelected = { fg = '@accent', bold = true },

          DiffviewStatusAdded = { fg = '@cyberCyan.600' },
          DiffviewStatusUntracked = { fg = '@cyberCyan.400' },
          DiffviewStatusModified = { fg = '@accent' },
          DiffviewStatusRenamed = { fg = '@cyberCyan.300' },
          DiffviewStatusCopied = { fg = '@cyberCyan.300' },
          DiffviewStatusTypeChange = { fg = '@cyberBlue.300' },
          DiffviewStatusTypeChanged = { fg = '@cyberBlue.300' },
          DiffviewStatusUnmerged = { fg = '@cyberPink.300' },
          DiffviewStatusUnknown = { fg = '@background.500' },
          DiffviewStatusDeleted = { fg = '@cyberPink.400' },
          DiffviewStatusBroken = { fg = '@cyberPink.400' },
          DiffviewStatusIgnored = { fg = '@background.500', italic = true },

          DiffviewFolderSign = { fg = '@cyberCyan.300' },
          DiffviewFolderName = { fg = '@cyberCyan.300' },

          DiffviewReference = { fg = '@cyberCyan.300' },
          DiffviewHash = { fg = '@background.500', italic = true },
        },
      },
    })

    -- v3 light: same shape as xeno-light-v1 above (compress the background
    -- scale toward its midpoint via negative contrast rather than overriding
    -- individual surfaces, so Normal/StatusLine/TabLine/NormalFloat/Pmenu all
    -- stay mutually consistent) -- built from the same v3 palette as the dark
    -- variant above.
    xeno.theme('xeno-cyberpunk-v3-light', {
      background = '#f3e8ff', -- purple-100 (low chroma -- stays muted once compressed)
      foreground = '#3c0366', -- purple-950
      accent = '#9810fa', -- purple-600

      transparent = false,

      properties = {
        contrast = -0.7,
        variation = 0.2,
        chroma = 0.5,
        lightness = 0,
      },

      min_contrast = 4.5,

      integrations = {
        ghostty = { update_config = false },
      },

      highlights = {
        editor = {
          CursorLineNr = { fg = '@accent' },
          CursorLine = { bg = xeno.opaque('@foreground.50', 0.05) },
          Visual = { bg = xeno.opaque('@accent.500', 0.2) },
          Search = { bg = xeno.opaque('@cyberCyan.500', 0.3) },
          IncSearch = { bg = xeno.opaque('@cyberCyan.500', 0.5) },
          PmenuSel = { bg = xeno.opaque('@accent.500', 0.25) },
          Directory = { fg = '@cyberCyan.200' },
          ErrorMsg = { fg = '@cyberPink.400' },
          WarningMsg = { fg = '@cyberOrange.400' },
        },
        syntax = {
          ['@comment'] = { fg = '@background.500', italic = true },
          -- Orange's in-gamut chroma ceiling drops off hard past ~L=.7 (dark
          -- scale) / ~L=.46 (light-variant override band) -- level .200 sits
          -- in a pale-salmon dead zone for this hue specifically (fine for
          -- green/blue/pink at that same level, just not orange). .300 is
          -- near max-vivid for orange in both variants; cyan bumped a level
          -- too for the same reason. This mismatch -- not the chroma property,
          -- which was already gamut-clipped -- was the main source of the
          -- "flat" feel vs v2 (green's ceiling stays high at .200, so v2
          -- never hit it).
          ['@string'] = { fg = '@cyberOrange.300' },
          ['@number'] = { fg = '@cyberCyan.200' },
          ['@boolean'] = { fg = '@cyberCyan.300' },
          ['@keyword'] = { fg = '@cyberBlue.400', bold = true },
          ['@function'] = { fg = '@accent' },
          ['@function.builtin'] = { fg = '@accent' },
          ['@variable'] = { fg = '@foreground.200' },
          ['@variable.builtin'] = { fg = '@cyberPink.300' },
          ['@type'] = { fg = '@cyberBlue.300' },
          ['@constant'] = { fg = '@cyberCyan.200' },
          ['@property'] = { fg = '@foreground.300' },
          ['@punctuation'] = { fg = '@background.500' },
          ['@tag'] = { fg = '@cyberPink.300' },
          Type = { link = '@type' },
        },
        plugins = {
          GitSignsAdd = { fg = '@cyberCyan.600' },
          GitSignsChange = { fg = '@accent' },
          GitSignsDelete = { fg = '@cyberPink.400' },
          TelescopeSelection = { bg = xeno.opaque('@accent.500', 0.15) },
          TelescopeMatching = { fg = '@cyberBlue.300', bold = true },

          DiffviewPrimary = { fg = '@accent' },
          DiffviewSecondary = { fg = '@cyberBlue.300' },
          DiffviewDim1 = { fg = '@background.500' },

          DiffviewFilePanelTitle = { fg = '@accent', bold = true },
          DiffviewFilePanelCounter = { fg = '@cyberBlue.400', bold = true },
          DiffviewFilePanelFileName = { fg = '@foreground.200' },
          DiffviewFilePanelPath = { fg = '@background.500' },
          DiffviewFilePanelInsertions = { fg = '@cyberCyan.600' },
          DiffviewFilePanelDeletions = { fg = '@cyberPink.400' },
          DiffviewFilePanelSelected = { fg = '@accent', bold = true },

          DiffviewStatusAdded = { fg = '@cyberCyan.600' },
          DiffviewStatusUntracked = { fg = '@cyberCyan.400' },
          DiffviewStatusModified = { fg = '@accent' },
          DiffviewStatusRenamed = { fg = '@cyberCyan.300' },
          DiffviewStatusCopied = { fg = '@cyberCyan.300' },
          DiffviewStatusTypeChange = { fg = '@cyberBlue.300' },
          DiffviewStatusTypeChanged = { fg = '@cyberBlue.300' },
          DiffviewStatusUnmerged = { fg = '@cyberPink.300' },
          DiffviewStatusUnknown = { fg = '@background.500' },
          DiffviewStatusDeleted = { fg = '@cyberPink.400' },
          DiffviewStatusBroken = { fg = '@cyberPink.400' },
          DiffviewStatusIgnored = { fg = '@background.500', italic = true },

          DiffviewFolderSign = { fg = '@cyberCyan.300' },
          DiffviewFolderName = { fg = '@cyberCyan.300' },

          DiffviewReference = { fg = '@cyberCyan.300' },
          DiffviewHash = { fg = '@background.500', italic = true },
        },
      },
    })

    -- xeno.theme() writes a static `require('xeno').setup(...)` file, but the
    -- light/dark shade math inside it is re-derived from `vim.o.background`
    -- at *activation* time (not baked in at generation time above) -- so
    -- switching between these two palettes needs `background` flipped right
    -- before the highlight groups get (re)computed.
    vim.api.nvim_create_autocmd('ColorSchemePre', {
      pattern = { 'xeno-cyberpunk-v2', 'xeno-light-v1', 'xeno-cyberpunk-v3-dark', 'xeno-cyberpunk-v3-light' },
      callback = function(args)
        local light_schemes = { ['xeno-light-v1'] = true, ['xeno-cyberpunk-v3-light'] = true }
        vim.o.background = light_schemes[args.match] and 'light' or 'dark'
      end,
    })

    vim.cmd 'colorscheme xeno-cyberpunk-v2'
  end,
}
