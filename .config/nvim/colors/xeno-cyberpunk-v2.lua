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
    green = "#a6e12d",
    magenta = "#FF237D",
    cyan = "#00d7ff"
  },
  highlights = {
    syntax = {
      ["@string"] = {
        fg = "@green.200"
      },
      Type = {
        link = "@type"
      },
      ["@comment"] = {
        italic = true,
        fg = "@background.500"
      },
      ["@tag"] = {
        fg = "@magenta.300"
      },
      ["@punctuation"] = {
        fg = "@background.500"
      },
      ["@property"] = {
        fg = "@foreground.300"
      },
      ["@constant"] = {
        fg = "@cyan.300"
      },
      ["@variable.builtin"] = {
        fg = "@magenta.300"
      },
      ["@variable"] = {
        fg = "@foreground.200"
      },
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
      ["@boolean"] = {
        fg = "@cyan.400"
      },
      ["@type"] = {
        fg = "@indigo.300"
      },
      ["@number"] = {
        fg = "@cyan.300"
      }
    },
    editor = {
      Normal = {
        bg = "@background.950",
        fg = "@foreground.100"
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
      Visual = {
        bg = {
          opacity = 0.2,
          __xeno_opaque = true,
          fg = "@accent.500"
        }
      },
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
      LineNr = {
        fg = "@background.500"
      }
    },
    plugins = {
      DiffviewStatusUnmerged = {
        fg = "@magenta.300"
      },
      DiffviewFilePanelSelected = {
        bold = true,
        fg = "@accent"
      },
      DiffviewStatusTypeChanged = {
        fg = "@indigo.300"
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
      DiffviewFilePanelCounter = {
        bold = true,
        fg = "@indigo.400"
      },
      DiffviewStatusAdded = {
        fg = "@green.600"
      },
      TelescopeSelection = {
        bg = {
          opacity = 0.15,
          __xeno_opaque = true,
          fg = "@accent.500"
        }
      },
      DiffviewDim1 = {
        fg = "@background.500"
      },
      DiffviewSecondary = {
        fg = "@indigo.300"
      },
      DiffviewPrimary = {
        fg = "@accent"
      },
      TelescopeMatching = {
        bold = true,
        fg = "@indigo.300"
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
      DiffviewFilePanelTitle = {
        bold = true,
        fg = "@accent"
      },
      DiffviewFilePanelDeletions = {
        fg = "@magenta.400"
      },
      DiffviewFolderName = {
        fg = "@cyan.300"
      },
      DiffviewStatusModified = {
        fg = "@accent"
      },
      DiffviewHash = {
        italic = true,
        fg = "@background.500"
      },
      DiffviewStatusRenamed = {
        fg = "@cyan.300"
      },
      DiffviewReference = {
        fg = "@cyan.300"
      },
      DiffviewStatusTypeChange = {
        fg = "@indigo.300"
      },
      DiffviewStatusCopied = {
        fg = "@cyan.300"
      },
      DiffviewFolderSign = {
        fg = "@cyan.300"
      },
      DiffviewStatusIgnored = {
        italic = true,
        fg = "@background.500"
      },
      DiffviewStatusBroken = {
        fg = "@magenta.400"
      },
      DiffviewStatusUntracked = {
        fg = "@green.400"
      },
      DiffviewStatusDeleted = {
        fg = "@magenta.400"
      },
      DiffviewStatusUnknown = {
        fg = "@background.500"
      }
    }
  },
})
vim.g.colors_name = "xeno-cyberpunk-v2"
