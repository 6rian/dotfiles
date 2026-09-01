require("xeno").setup({
  background = "#0B041A",
  accent = "#6C23FF",
  properties = {
    contrast = 0.1,
    variation = 0.2,
    chroma = 0.5,
    lightness = 0.0,
  },
  min_contrast = 4.50,
  transparent = true,
  foreground = "#eef1f0",
  _custom_colors = {
    magenta = "#FF237D",
    indigo = "#7c83fd",
    cyan = "#00d7ff",
    green = "#a6e12d"
  },
  highlights = {
    syntax = {
      Type = {
        link = "@type"
      },
      ["@boolean"] = {
        fg = "@cyan.400"
      },
      ["@tag"] = {
        fg = "@magenta.300"
      },
      ["@number"] = {
        fg = "@cyan.300"
      },
      ["@string"] = {
        fg = "@green.200"
      },
      ["@comment"] = {
        fg = "@background.500",
        italic = true
      },
      ["@punctuation"] = {
        fg = "@background.500"
      },
      ["@constant"] = {
        fg = "@cyan.300"
      },
      ["@property"] = {
        fg = "@foreground.300"
      },
      ["@variable.builtin"] = {
        fg = "@magenta.300"
      },
      ["@variable"] = {
        fg = "@foreground.200"
      },
      ["@type"] = {
        fg = "@indigo.300"
      },
      ["@function.builtin"] = {
        fg = "@accent"
      },
      ["@function"] = {
        fg = "@accent"
      },
      ["@keyword"] = {
        fg = "@indigo.400",
        bold = true
      }
    },
    editor = {
      CursorLine = {
        bg = {
          opacity = 0.05,
          __xeno_opaque = true,
          fg = "@foreground.50"
        }
      },
      CursorLineNr = {
        fg = "@accent"
      },
      IncSearch = {
        bg = {
          opacity = 0.5,
          __xeno_opaque = true,
          fg = "@cyan.500"
        }
      },
      WarningMsg = {
        fg = "@accent"
      },
      ErrorMsg = {
        fg = "@magenta.400"
      },
      Directory = {
        fg = "@cyan.300"
      },
      PmenuSel = {
        bg = {
          opacity = 0.25,
          __xeno_opaque = true,
          fg = "@accent.500"
        }
      },
      Pmenu = {
        bg = "@background.800",
        fg = "@foreground.200"
      },
      Search = {
        bg = {
          opacity = 0.3,
          __xeno_opaque = true,
          fg = "@cyan.500"
        }
      },
      LineNr = {
        fg = "@background.500"
      },
      Visual = {
        bg = {
          opacity = 0.2,
          __xeno_opaque = true,
          fg = "@accent.500"
        }
      },
      Normal = {
        fg = "@foreground.100",
        bg = "@background.950"
      }
    },
    plugins = {
      TelescopeMatching = {
        fg = "@indigo.300",
        bold = true
      },
      GitSignsDelete = {
        fg = "@magenta.400"
      },
      GitSignsChange = {
        fg = "@accent"
      },
      GitSignsAdd = {
        fg = "@green.600"
      },
      TelescopeSelection = {
        bg = {
          opacity = 0.15,
          __xeno_opaque = true,
          fg = "@accent.500"
        }
      }
    }
  },
})
vim.g.colors_name = "xeno-cyberpunk-v2"
