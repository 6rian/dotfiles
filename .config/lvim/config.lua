-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

lvim.plugins = {
  { "tiagovla/tokyodark.nvim" },
  { "EdenEast/nightfox.nvim" },
}

-- lvim.colorscheme = "tokyodark"
lvim.colorscheme = "carbonfox"

lvim.format_on_save = true

vim.o.relativenumber = true
vim.o.number = true

-- =====================================================================
-- = Keybindings
-- =====================================================================

local opts = { noremap = true, silent = true }

local keymap = vim.api.nvim_set_keymap

-- Exit insert mode
keymap("i", "jk", "<ESC>", opts)
keymap("i", "kj", "<ESC>", opts)
