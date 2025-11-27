local myCyberpunkColors = {
  rosewater = '#FF10F0',
  flamingo = '#D946EF',
  pink = '#FF1493',
  mauve = '#B24BF3',
  red = '#FF006E',
  maroon = '#C026D3',
  peach = '#FFA329',
  yellow = '#D4FF00',
  green = '#40D432',
  teal = '#00E5FF',
  sky = '#00D7FF',
  sapphire = '#00E0FF',
  blue = '#00E8FF',
  lavender = '#A78BFA',
  text = '#B1FF8A',
  subtext1 = '#8FB4FF',
  subtext0 = '#7DA3E8',
  overlay2 = '#8B5CF6',
  overlay1 = '#7C3AED',
  overlay0 = '#6D28D9',
  -- surface2 = '#1E1B2E',
  -- surface1 = '#130E29',
  -- surface0 = '#0F0D17',
  surface2 = '#3A3D4A',
  surface1 = '#26233A',
  surface0 = '#1D1E29',
  base = '#08050E',
  mantle = '#0A0811',
  crust = '#06040B',
}

-- local myColors = {
--   rosewater = '#F5B8AB',
--   flamingo = '#F29D9D',
--   pink = '#AD6FF7',
--   mauve = '#FF8F40',
--   red = '#E66767',
--   maroon = '#EB788B',
--   peach = '#FAB770',
--   yellow = '#FACA64',
--   green = '#70CF67',
--   teal = '#4CD4BD',
--   sky = '#61BDFF',
--   sapphire = '#4BA8FA',
--   blue = '#00BFFF',
--   lavender = '#00BBCC',
--   text = '#C1C9E6',
--   subtext1 = '#A3AAC2',
--   subtext0 = '#8E94AB',
--   overlay2 = '#7D8296',
--   overlay1 = '#676B80',
--   overlay0 = '#464957',
--   surface2 = '#3A3D4A',
--   surface1 = '#2F313D',
--   surface0 = '#1D1E29',
--   base = '#0b0b12',
--   mantle = '#11111a',
--   crust = '#191926',
-- }

return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  opts = {
    flavour = 'macchiato', -- latte, frappe, macchiato, mocha
    background = { -- :h background
      light = 'latte',
      dark = 'mocha',
    },
    transparent_background = true, -- disables setting the background color.
    show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
    term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
    dim_inactive = {
      enabled = true, -- dims the background color of inactive window
      shade = 'dark',
      percentage = 0.7, -- percentage of the shade to apply to the inactive window
    },
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    no_underline = false, -- Force no underline
    styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
      comments = { 'italic' }, -- Change the style of comments
      conditionals = { 'italic' },
      loops = {},
      functions = {},
      keywords = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = {},
      operators = {},
      -- miscs = {}, -- Uncomment to turn off hard-coded styles
    },
    highlight_overrides = {
      all = function(colors)
        return {
          CurSearch = { bg = colors.sky },
          IncSearch = { bg = colors.sky },
          -- LineNr = { fg = colors.overlay0 }, -- Relative line numbers
          CursorLineNr = { fg = colors.blue, style = { 'bold' } },
          DashboardFooter = { fg = colors.overlay0 },
          TreesitterContextBottom = { style = {} },
          WinSeparator = { fg = colors.overlay0, style = { 'bold' } },
          ['@markup.italic'] = { fg = colors.blue, style = { 'italic' } },
          ['@markup.strong'] = { fg = colors.blue, style = { 'bold' } },
          Headline = { style = { 'bold' } },
          Headline1 = { fg = colors.blue, style = { 'bold' } },
          Headline2 = { fg = colors.pink, style = { 'bold' } },
          Headline3 = { fg = colors.lavender, style = { 'bold' } },
          Headline4 = { fg = colors.green, style = { 'bold' } },
          Headline5 = { fg = colors.peach, style = { 'bold' } },
          Headline6 = { fg = colors.flamingo, style = { 'bold' } },
          rainbow1 = { fg = colors.blue, style = { 'bold' } },
          rainbow2 = { fg = colors.pink, style = { 'bold' } },
          rainbow3 = { fg = colors.lavender, style = { 'bold' } },
          rainbow4 = { fg = colors.green, style = { 'bold' } },
          rainbow5 = { fg = colors.peach, style = { 'bold' } },
          rainbow6 = { fg = colors.flamingo, style = { 'bold' } },
        }
      end,
    },
    color_overrides = {
      macchiato = myCyberpunkColors,
    },
    custom_highlights = function(colors)
      return {
        -- Telescope
        FloatBorder = { fg = myCyberpunkColors.overlay0, bg = myCyberpunkColors.crust },
        FloatTitle = { fg = myCyberpunkColors.yellow, bg = '#000000', style = { 'bold' } },
        NormalFloat = { fg = myCyberpunkColors.sky, bg = myCyberpunkColors.crust },
        TelescopeSelection = {
          bg = myCyberpunkColors.crust,
          bold = true,
          cterm = {
            bold = true,
          },
          fg = myCyberpunkColors.sky,
        },

        FloatermBorder = { fg = myCyberpunkColors.overlay0, bg = '#000000' },

        SnacksDashboardKey = { fg = myCyberpunkColors.green },
        SnacksDashboardFooter = { fg = myCyberpunkColors.flamingo },
        SnacksDashboardTitle = { fg = myCyberpunkColors.yellow },

        SnacksPickerBorder = { fg = myCyberpunkColors.overlay0 }, -- lazygit, file picker border
        SnacksPickerDirectory = { fg = myCyberpunkColors.green },
        SnacksPickerPathHidden = { fg = myCyberpunkColors.red },
      }
    end,
    default_integrations = true,
    integrations = {
      blink_cmp = {
        style = 'bordered',
      },
      cmp = true,
      gitsigns = true,
      fzf = true,
      lsp_trouble = true,
      markdown = true,
      mason = true,
      neotree = true,
      nvimtree = true,
      treesitter = true,
      treesitter_context = true,
      notify = false,
      mini = {
        enabled = true,
        indentscope_color = '',
      },
      snacks = {
        enabled = true,
        indent_scope_color = '', -- catppuccin color (eg. `lavender`) Default: text
      },
      telescope = {
        enabled = true,
        style = 'nvchad',
      },
      -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    },
    init = function()
      vim.cmd.colorscheme 'catppuccin'
    end,
  },
}
