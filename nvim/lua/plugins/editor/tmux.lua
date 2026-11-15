return {
  {
    -- Owns <C-h/j/k/l> (navigation defaults on) and <A-h/j/k/l> resize, for
    -- moving between nvim splits and tmux panes.
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
}
