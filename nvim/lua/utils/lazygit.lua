-- Helpers for lazygit's `e` (edit) when lazygit runs inside nvim via Snacks.
--
-- lazygit's built-in `nvim-remote` preset opens the file with `--remote-tab`,
-- i.e. in a new tab. The `os.edit`/`os.editAtLine` commands set in
-- `plugins/editor/snacks.lua` call `leave()` below first, then `--remote`
-- (`:drop`), so the file opens in the window lazygit was started from.
local M = {}

--- Called by lazygit through `nvim --server "$NVIM" --remote-expr`.
--- If the current window is a floating terminal (the Snacks lazygit float),
--- queue a `q` so lazygit quits as soon as its edit command returns (Snacks
--- then closes the float), and move to the previous window.
---@return string
function M.leave()
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(win)
  if vim.bo[buf].buftype == 'terminal' and vim.api.nvim_win_get_config(win).relative ~= '' then
    vim.api.nvim_chan_send(vim.bo[buf].channel, 'q')
    vim.cmd.wincmd 'p'
  end
  return ''
end

return M
