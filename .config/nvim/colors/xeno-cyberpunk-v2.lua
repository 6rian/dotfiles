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
      ["@tag"] = {
        fg = "@magenta.300"
      },
      ["@function.builtin"] = {
        fg = "@accent"
      },
      ["@property"] = {
        fg = "@foreground.300"
      },
      ["@keyword"] = {
        fg = "@indigo.400",
        bold = true
      },
      ["@constant"] = {
        fg = "@cyan.300"
      },
      ["@number"] = {
        fg = "@cyan.300"
      },
      ["@string"] = {
        fg = "@green.200"
      },
      ["@variable.builtin"] = {
        fg = "@magenta.300"
      },
      ["@comment"] = {
        fg = "@background.500",
        italic = true
      },
      ["@boolean"] = {
        fg = "@cyan.400"
      },
      ["@punctuation"] = {
        fg = "@background.500"
      },
      ["@function"] = {
        fg = "@accent"
      },
      ["@variable"] = {
        fg = "@foreground.200"
      },
      Type = {
        link = "@type"
      },
      ["@type"] = {
        fg = "@indigo.300"
      }
    },
    plugins = {
      DiffviewStatusUnknown = {
        fg = "@background.500"
      },
      DiffviewStatusUnmerged = {
        fg = "@magenta.300"
      },
      DiffviewStatusTypeChanged = {
        fg = "@indigo.300"
      },
      DiffviewStatusUntracked = {
        fg = "@green.400"
      },
      DiffviewStatusTypeChange = {
        fg = "@indigo.300"
      },
      DiffviewStatusCopied = {
        fg = "@cyan.300"
      },
      DiffviewStatusRenamed = {
        fg = "@cyan.300"
      },
      DiffviewStatusModified = {
        fg = "@accent"
      },
      DiffviewSecondary = {
        fg = "@indigo.300"
      },
      TelescopeSelection = {
        bg = {
          opacity = 0.15,
          __xeno_opaque = true,
          fg = "@accent.500"
        }
      },
      GitSignsAdd = {
        fg = "@green.600"
      },
      DiffviewStatusAdded = {
        fg = "@green.600"
      },
      GitSignsChange = {
        fg = "@accent"
      },
      DiffviewFilePanelSelected = {
        fg = "@accent",
        bold = true
      },
      DiffviewFilePanelDeletions = {
        fg = "@magenta.400"
      },
      DiffviewFilePanelInsertions = {
        fg = "@green.600"
      },
      DiffviewFilePanelPath = {
        fg = "@background.500"
      },
      DiffviewFilePanelFileName = {
        fg = "@foreground.200"
      },
      GitSignsDelete = {
        fg = "@magenta.400"
      },
      DiffviewFilePanelCounter = {
        fg = "@indigo.400",
        bold = true
      },
      DiffviewFolderName = {
        fg = "@cyan.300"
      },
      DiffviewFilePanelTitle = {
        fg = "@accent",
        bold = true
      },
      DiffviewDim1 = {
        fg = "@background.500"
      },
      DiffviewReference = {
        fg = "@cyan.300"
      },
      DiffviewPrimary = {
        fg = "@accent"
      },
      TelescopeMatching = {
        fg = "@indigo.300",
        bold = true
      },
      DiffviewFolderSign = {
        fg = "@cyan.300"
      },
      DiffviewStatusIgnored = {
        fg = "@background.500",
        italic = true
      },
      DiffviewStatusBroken = {
        fg = "@magenta.400"
      },
      DiffviewHash = {
        fg = "@background.500",
        italic = true
      },
      DiffviewStatusDeleted = {
        fg = "@magenta.400"
      }
    },
    editor = {
      CursorLineNr = {
        fg = "@accent"
      },
      Visual = {
        bg = {
          opacity = 0.2,
          __xeno_opaque = true,
          fg = "@accent.500"
        }
      },
      IncSearch = {
        bg = {
          opacity = 0.5,
          __xeno_opaque = true,
          fg = "@cyan.500"
        }
      },
      CursorLine = {
        bg = {
          opacity = 0.05,
          __xeno_opaque = true,
          fg = "@foreground.50"
        }
      },
      LineNr = {
        fg = "@background.500"
      },
      Normal = {
        fg = "@foreground.100",
        bg = "@background.950"
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
        fg = "@foreground.200",
        bg = "@background.800"
      },
      WarningMsg = {
        fg = "@accent"
      },
      Search = {
        bg = {
          opacity = 0.3,
          __xeno_opaque = true,
          fg = "@cyan.500"
        }
      }
    }
  },
})
vim.g.colors_name = "xeno-cyberpunk-v2"
