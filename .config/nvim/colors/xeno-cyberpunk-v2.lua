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
    green = "#a6e12d",
    indigo = "#7c83fd",
    cyan = "#00d7ff",
    magenta = "#FF237D"
  },
  highlights = {
    plugins = {
      DiffviewFilePanelTitle = {
        bold = true,
        fg = "@accent"
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
      DiffviewFolderName = {
        fg = "@cyan.300"
      },
      DiffviewStatusDeleted = {
        fg = "@magenta.400"
      },
      DiffviewStatusUnknown = {
        fg = "@background.500"
      },
      DiffviewStatusUnmerged = {
        fg = "@magenta.300"
      },
      DiffviewReference = {
        fg = "@cyan.300"
      },
      DiffviewStatusTypeChanged = {
        fg = "@indigo.300"
      },
      GitSignsAdd = {
        fg = "@green.600"
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
      TelescopeSelection = {
        bg = {
          fg = "@accent.500",
          opacity = 0.15,
          __xeno_opaque = true
        }
      },
      DiffviewStatusUntracked = {
        fg = "@green.400"
      },
      GitSignsChange = {
        fg = "@accent"
      },
      DiffviewStatusAdded = {
        fg = "@green.600"
      },
      GitSignsDelete = {
        fg = "@magenta.400"
      },
      DiffviewFilePanelSelected = {
        bold = true,
        fg = "@accent"
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
      DiffviewHash = {
        italic = true,
        fg = "@background.500"
      },
      DiffviewFilePanelCounter = {
        bold = true,
        fg = "@indigo.400"
      }
    },
    syntax = {
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
      ["@number"] = {
        fg = "@cyan.300"
      },
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
      ["@type"] = {
        fg = "@indigo.300"
      },
      ["@constant"] = {
        fg = "@cyan.300"
      }
    },
    editor = {
      PmenuSel = {
        bg = {
          fg = "@accent.500",
          opacity = 0.25,
          __xeno_opaque = true
        }
      },
      Search = {
        bg = {
          fg = "@cyan.500",
          opacity = 0.3,
          __xeno_opaque = true
        }
      },
      Visual = {
        bg = {
          fg = "@accent.500",
          opacity = 0.2,
          __xeno_opaque = true
        }
      },
      WarningMsg = {
        fg = "@accent"
      },
      Normal = {
        bg = "@background.950",
        fg = "@foreground.100"
      },
      CursorLine = {
        bg = {
          fg = "@foreground.50",
          opacity = 0.05,
          __xeno_opaque = true
        }
      },
      Directory = {
        fg = "@cyan.300"
      },
      ErrorMsg = {
        fg = "@magenta.400"
      },
      LineNr = {
        fg = "@background.500"
      },
      CursorLineNr = {
        fg = "@accent"
      },
      Pmenu = {
        bg = "@background.800",
        fg = "@foreground.200"
      },
      IncSearch = {
        bg = {
          fg = "@cyan.500",
          opacity = 0.5,
          __xeno_opaque = true
        }
      }
    }
  },
})
vim.g.colors_name = "xeno-cyberpunk-v2"
