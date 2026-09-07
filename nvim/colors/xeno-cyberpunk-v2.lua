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
    cyan = "#00d7ff",
    indigo = "#7c83fd",
    green = "#a6e12d",
    magenta = "#FF237D"
  },
  highlights = {
    syntax = {
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
      }
    },
    editor = {
      ErrorMsg = {
        fg = "@magenta.400"
      },
      Directory = {
        fg = "@cyan.300"
      },
      PmenuSel = {
        bg = {
          fg = "@accent.500",
          opacity = 0.25,
          __xeno_opaque = true
        }
      },
      Pmenu = {
        bg = "@background.800",
        fg = "@foreground.200"
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
      IncSearch = {
        bg = {
          fg = "@cyan.500",
          opacity = 0.5,
          __xeno_opaque = true
        }
      },
      CursorLineNr = {
        fg = "@accent"
      },
      LineNr = {
        fg = "@background.500"
      },
      Normal = {
        bg = "@background.950",
        fg = "@foreground.100"
      },
      WarningMsg = {
        fg = "@accent"
      },
      CursorLine = {
        bg = {
          fg = "@foreground.50",
          opacity = 0.05,
          __xeno_opaque = true
        }
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
      TelescopeSelection = {
        bg = {
          fg = "@accent.500",
          opacity = 0.15,
          __xeno_opaque = true
        }
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
      DiffviewStatusUntracked = {
        fg = "@green.400"
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
      GitSignsDelete = {
        fg = "@magenta.400"
      },
      DiffviewFilePanelCounter = {
        bold = true,
        fg = "@indigo.400"
      },
      DiffviewFolderName = {
        fg = "@cyan.300"
      },
      DiffviewFilePanelTitle = {
        bold = true,
        fg = "@accent"
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
      DiffviewHash = {
        italic = true,
        fg = "@background.500"
      },
      DiffviewStatusDeleted = {
        fg = "@magenta.400"
      }
    }
  },
})
vim.g.colors_name = "xeno-cyberpunk-v2"
