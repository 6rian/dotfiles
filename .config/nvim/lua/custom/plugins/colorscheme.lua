return {
  'aliqyan-21/darkvoid.nvim',
  opts = {
    -- custom options here
    transparent = true,
    glow = true,
    show_end_of_buffer = true,

    colors = {
      fg = '#c0c0c0',
      bg = '#1c1c1c',
      cursor = '#bdfe58',
      line_nr = '#634A9F',
      visual = '#12024D',
      comment = '#493F48',
      string = '#AFA0FF',
      func = '#732EC6',
      kw = '#A6E12D',
      identifier = '#D5D2F9',
      type = '#00D7FF',
      type_builtin = '#00D7FF', -- current
      -- type_builtin = "#8cf8f7", -- glowy blue old (was present by default before type_builtin was introduced added here for people who may like it)
      search_highlight = '#A6E12D',
      operator = '#BDFE58',
      bracket = '#e6e6e6',
      preprocessor = '#4b8902',
      bool = '#BE2EC6',
      constant = '#BE2EC6',

      -- enable or disable specific plugin highlights
      plugins = {
        gitsigns = true,
        nvim_cmp = true,
        treesitter = true,
        nvimtree = true,
        telescope = true,
        lualine = true,
        bufferline = true,
        oil = true,
        whichkey = true,
        nvim_notify = true,
      },

      -- gitsigns colors
      added = '#A6E12D',
      changed = '#F7FF2B',
      removed = '#F690ED',

      -- Pmenu colors
      pmenu_bg = '#1c1c1c',
      pmenu_sel_bg = '#A6E12D',
      pmenu_fg = '#c0c0c0',

      -- EndOfBuffer color
      eob = '#3c3c3c',

      -- Telescope specific colors
      border = '#4B2BC4',
      title = '#bdfe58',

      -- bufferline specific colors
      bufferline_selection = '#A6E12D',

      -- LSP diagnostics colors
      error = '#FF458E',
      warning = '#FF9900',
      hint = '#bedc74',
      info = '#7fa1c3',
    },
  },
  config = function(_, opts)
    require('darkvoid').setup(opts) -- calling setup is optional
    vim.cmd [[colorscheme darkvoid]]
  end,
}
