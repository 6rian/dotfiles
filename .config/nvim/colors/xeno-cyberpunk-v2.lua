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
    syntax = {
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
      ["@type"] = {
        fg = "@indigo.300"
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
      ["@comment"] = {
        italic = true,
        fg = "@background.500"
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
      }
    },
    editor = {
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
      CursorLine = {
        bg = {
          opacity = 0.05,
          __xeno_opaque = true,
          fg = "@foreground.50"
        }
      },
      Visual = {
        bg = {
          opacity = 0.2,
          __xeno_opaque = true,
          fg = "@accent.500"
        }
      }
    },
    plugins = {
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
      GitSignsDelete = {
        fg = "@magenta.400"
      },
      GitSignsChange = {
        fg = "@accent"
      },
      DiffviewStatusBroken = {
        fg = "@magenta.400"
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
      GitSignsAdd = {
        fg = "@green.600"
      },
      TelescopeSelection = {
        bg = {
          opacity = 0.15,
          __xeno_opaque = true,
          fg = "@accent.500"
        }
      },
      DiffviewHash = {
        italic = true,
        fg = "@background.500"
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
      DiffviewStatusTypeChanged = {
        fg = "@indigo.300"
      },
      DiffviewStatusAdded = {
        fg = "@green.600"
      },
      DiffviewStatusIgnored = {
        italic = true,
        fg = "@background.500"
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
      DiffviewFolderName = {
        fg = "@cyan.300"
      },
      DiffviewFilePanelCounter = {
        bold = true,
        fg = "@indigo.400"
      },
      DiffviewFolderSign = {
        fg = "@cyan.300"
      },
      DiffviewFilePanelTitle = {
        bold = true,
        fg = "@accent"
      },
      DiffviewDim1 = {
        fg = "@background.500"
      }
    }
  },
})
vim.g.colors_name = "xeno-cyberpunk-v2"
