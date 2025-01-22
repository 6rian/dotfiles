return {
  '0xstepit/flow.nvim',
  lazy = false,
  priority = 1000,
  tag = 'v2.0.1',
  opts = {
    theme = {
      style = 'dark', --  "dark" | "light"
      contrast = 'high', -- "default" | "high"
      transparent = true, -- true | false
    },
    colors = {
      mode = 'default', -- "default" | "dark" | "light"
      fluo = 'pink', -- "pink" | "cyan" | "yellow" | "orange" | "green"
    },
    ui = {
      borders = 'theme', -- "theme" | "inverse" | "fluo" | "none"
      aggressive_spell = false, -- true | false
    },
  },
  config = function(_, opts)
    require('flow').setup(opts)
    vim.cmd 'colorscheme flow'
  end,
}

-- return {
--   'scottmckendry/cyberdream.nvim',
--   lazy = false,
--   priority = 1000,
--   opts = {
--     transparent = true,
--     borderless_telescope = false, -- removes bg color from telescope
--     italic_comments = true,
--     theme = {
--       saturation = 1,
--     },
--     -- extensions = {
--     --   lualine = false,
--     -- },
--   },
--   config = function(_, opts)
--     require('cyberdream').setup(opts)
--     vim.cmd [[colorscheme cyberdream]]
--   end,
-- }

-- return {
--   'tiagovla/tokyodark.nvim',
--   opts = {
--     -- custom options here
--     transparent_background = true,
--   },
--   config = function(_, opts)
--     require('tokyodark').setup(opts) -- calling setup is optional
--     vim.cmd [[colorscheme tokyodark]]
--   end,
-- }

-- return {
--   'olivercederborg/poimandres.nvim',
--   lazy = false,
--   priority = 1000,
--   config = function()
--     require('poimandres').setup {
--       -- leave this setup function empty for default config
--       -- or refer to the configuration section
--       -- for configuration options
--
--       bold_vert_split = false, -- use bold vertical separators
--       dim_nc_background = false, -- dim 'non-current' window backgrounds
--       disable_background = false, -- disable background
--       disable_float_background = false, -- disable background for floats
--       disable_italics = false, -- disable italics
--     }
--   end,
--
--   -- optionally set the colorscheme within lazy config
--   init = function()
--     vim.cmd 'colorscheme poimandres'
--   end,
-- }

-- return {
--   'nuvic/flexoki-nvim',
--   name = 'flexoki',
--   config = function()
--     require('flexoki').setup {
--       variant = 'auto', -- auto, moon, or dawn
--       dim_inactive_windows = false,
--       extend_background_behind_borders = true,
--
--       enable = {
--         terminal = true,
--         legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
--         migrations = true, -- Handle deprecated options automatically
--       },
--
--       styles = {
--         bold = true,
--         italic = false,
--         transparency = true,
--       },
--
--       groups = {
--         border = 'muted',
--         link = 'purple_two',
--         panel = 'surface',
--
--         error = 'red_one',
--         hint = 'purple_one',
--         info = 'cyan_one',
--         ok = 'green_one',
--         warn = 'orange_one',
--         note = 'blue_one',
--         todo = 'magenta_one',
--
--         git_add = 'green_one',
--         git_change = 'yellow_one',
--         git_delete = 'red_one',
--         git_dirty = 'yellow_one',
--         git_ignore = 'muted',
--         git_merge = 'purple_one',
--         git_rename = 'blue_one',
--         git_stage = 'purple_one',
--         git_text = 'magenta_one',
--         git_untracked = 'subtle',
--
--         h1 = 'purple_two',
--         h2 = 'cyan_two',
--         h3 = 'magenta_two',
--         h4 = 'orange_two',
--         h5 = 'blue_two',
--         h6 = 'cyan_two',
--       },
--
--       palette = {
--         -- Override the builtin palette per variant
--         -- moon = {
--         --     base = '#100f0f',
--         --     overlay = '#1c1b1a',
--         -- },
--       },
--
--       highlight_groups = {
--         -- Comment = { fg = "subtle" },
--         -- VertSplit = { fg = "muted", bg = "muted" },
--       },
--
--       before_highlight = function(group, highlight, palette)
--         -- Disable all undercurls
--         -- if highlight.undercurl then
--         --     highlight.undercurl = false
--         -- end
--         --
--         -- Change palette colour
--         -- if highlight.fg == palette.blue_two then
--         --     highlight.fg = palette.cyan_two
--         -- end
--       end,
--     }
--
--     vim.cmd 'colorscheme flexoki'
--     -- vim.cmd("colorscheme flexoki-moon")
--     -- vim.cmd("colorscheme flexoki-dawn")
--   end,
-- }

-- return {
--   'aliqyan-21/darkvoid.nvim',
--   opts = {
--     -- custom options here
--     transparent = true,
--     glow = true,
--     show_end_of_buffer = true,
--
--     colors = {
--       fg = '#c0c0c0',
--       bg = '#1c1c1c',
--       cursor = '#bdfe58',
--       line_nr = '#634A9F',
--       visual = '#12024D',
--       comment = '#493F48',
--       string = '#AFA0FF',
--       func = '#732EC6',
--       kw = '#A6E12D',
--       identifier = '#D5D2F9',
--       type = '#00D7FF',
--       type_builtin = '#00D7FF', -- current
--       -- type_builtin = "#8cf8f7", -- glowy blue old (was present by default before type_builtin was introduced added here for people who may like it)
--       search_highlight = '#A6E12D',
--       operator = '#BDFE58',
--       bracket = '#e6e6e6',
--       preprocessor = '#4b8902',
--       bool = '#BE2EC6',
-- constant = '#BE2EC6',
--
--       -- enable or disable specific plugin highlights
--       plugins = {
--         gitsigns = true,
--         nvim_cmp = true,
--         treesitter = true,
--         nvimtree = true,
--         telescope = true,
--         lualine = true,
--         bufferline = true,
--         oil = true,
--         whichkey = true,
--         nvim_notify = true,
--       },
--
--       -- gitsigns colors
--       added = '#A6E12D',
--       changed = '#F7FF2B',
--       removed = '#F690ED',
--
--       -- Pmenu colors
--       pmenu_bg = '#1c1c1c',
--       pmenu_sel_bg = '#A6E12D',
--       pmenu_fg = '#c0c0c0',
--
--       -- EndOfBuffer color
--       eob = '#3c3c3c',
--
--       -- Telescope specific colors
--       border = '#4B2BC4',
--       title = '#bdfe58',
--
--       -- bufferline specific colors
--       bufferline_selection = '#A6E12D',
--
--       -- LSP diagnostics colors
--       error = '#FF458E',
--       warning = '#FF9900',
--       hint = '#bedc74',
--       info = '#7fa1c3',
--     },
--   },
--   config = function(_, opts)
--     require('darkvoid').setup(opts) -- calling setup is optional
--     vim.cmd [[colorscheme darkvoid]]
--   end,
-- }
