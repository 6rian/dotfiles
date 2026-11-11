return {
  {
    'aserowy/tmux.nvim',
    config = function()
      return require('tmux').setup {
        resize = {
          enable_default_keybindings = true,
        },
        -- Off: copy_sync overwrites vim.g.clipboard with tmux's own paste
        -- buffer (so `p` never sees the system clipboard) and remaps p/P/"/<C-r>.
        -- The system clipboard is handled by OSC 52 instead — see options.lua.
        copy_sync = {
          enable = false,
        },
      }
    end,
  },
  {
    'christoomey/vim-tmux-navigator',
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
      'TmuxNavigatePrevious',
      'TmuxNavigatorProcessList',
    },
    keys = {
      { '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>' },
      { '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>' },
      { '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>' },
      { '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>' },
      { '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>' },
    },
  },
}
