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
    indigo = "#7c83fd",
    magenta = "#FF237D",
    green = "#a6e12d",
    cyan = "#00d7ff"
  },
  highlights = {
    syntax = {
      ["@function.builtin"] = {
        fg = "@accent"
      },
      ["@function"] = {
        fg = "@accent"
      },
      ["@keyword"] = {
        bold = true,
        fg = "@indigo.400"
      },
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
      ["@type"] = {
        fg = "@indigo.300"
      },
      ["@comment"] = {
        italic = true,
        fg = "@background.500"
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
      }
    },
    plugins = {
      GitSignsChange = {
        fg = "@accent"
      },
      GitSignsAdd = {
        fg = "@green.600"
      },
      TelescopeMatching = {
        bold = true,
        fg = "@indigo.300"
      },
      GitSignsDelete = {
        fg = "@magenta.400"
      },
      TelescopeSelection = {
        bg = {
          __xeno_opaque = true,
          fg = "@accent.500",
          opacity = 0.15
        }
      }
    },
    editor = {
      Search = {
        bg = {
          __xeno_opaque = true,
          fg = "@cyan.500",
          opacity = 0.3
        }
      },
      WarningMsg = {
        fg = "@accent"
      },
      Visual = {
        bg = {
          __xeno_opaque = true,
          fg = "@accent.500",
          opacity = 0.2
        }
      },
      CursorLine = {
        bg = {
          __xeno_opaque = true,
          fg = "@foreground.50",
          opacity = 0.05
        }
      },
      LineNr = {
        fg = "@background.500"
      },
      CursorLineNr = {
        fg = "@accent"
      },
      IncSearch = {
        bg = {
          __xeno_opaque = true,
          fg = "@cyan.500",
          opacity = 0.5
        }
      },
      ErrorMsg = {
        fg = "@magenta.400"
      },
      Directory = {
        fg = "@cyan.300"
      },
      PmenuSel = {
        bg = {
          __xeno_opaque = true,
          fg = "@accent.500",
          opacity = 0.25
        }
      },
      Pmenu = {
        fg = "@foreground.200",
        bg = "@background.800"
      },
      Normal = {
        bg = "@background.950",
        fg = "@foreground.100"
      }
    }
  },
})
vim.g.colors_name = "xeno-cyberpunk-v2"
