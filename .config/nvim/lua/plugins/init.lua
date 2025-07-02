-- Custom Plugin Keymaps
local keymap = vim.keymap

-- Colorizer
keymap.set('n', '<leader>ca', '<cmd>ColorizerAttachToBuffer<CR>', { desc = 'Colorizer: Attach to buffer', noremap = true })
keymap.set('n', '<leader>cd', '<cmd>ColorizerDetachFromBuffer<CR>', { desc = 'Colorizer: Attach to buffer', noremap = true })
keymap.set('n', '<leader>ct', '<cmd>ColorizerReloadAllBuffers<CR>', { desc = 'Colorizer: Attach to buffer', noremap = true })
keymap.set('n', '<leader>cr', '<cmd>ColorizerToggle<CR>', { desc = 'Colorizer: Attach to buffer', noremap = true })

return {
  -- { import = 'plugins.ai.copilot' },
  { import = 'plugins.ai.avante' },

  { import = 'plugins.coding.autotag' },
  { import = 'plugins.coding.highlights' },
  { import = 'plugins.coding.lsp' },
  { import = 'plugins.coding.todo-comments' },
  { import = 'plugins.coding.trouble' },

  { import = 'plugins.editor.blink' },
  { import = 'plugins.editor.bufferline' },
  { import = 'plugins.editor.gitsigns' },
  { import = 'plugins.editor.guess-indent' },
  { import = 'plugins.editor.lazygit' },
  { import = 'plugins.editor.lualine' },
  { import = 'plugins.editor.mini' },
  { import = 'plugins.editor.neo-tree' },
  { import = 'plugins.editor.snacks' },
  { import = 'plugins.editor.telescope' },
  { import = 'plugins.editor.tmux' },

  { import = 'plugins.formatting.conform' },

  { import = 'plugins.ui.colorizer' },
  { import = 'plugins.ui.colorschemes.catppuccin' },
  -- { import = 'plugins.ui.colorschemes.citruszest' },
  -- { import = 'plugins.ui.colorschemes.cyberdream' },
  -- { import = 'plugins.ui.colorschemes.flouromachine' },
  -- { import = 'plugins.ui.colorschemes.material' },
  -- { import = 'plugins.ui.colorschemes.rosepine' },
  -- { import = 'plugins.ui.colorschemes.tokyonight' },
  { import = 'plugins.ui.markdown' },
  { import = 'plugins.ui.treesitter-context' },

  { import = 'plugins.utils.fine-cmdline' },
  { import = 'plugins.utils.vim-floaterm' },
  { import = 'plugins.utils.which-key' },
}
