-- with lazy.nvim
return {
  'LintaoAmons/bookmarks.nvim',
  -- pin the plugin at specific version for stability
  -- backup your bookmark sqlite db when there are breaking changes
  -- tag = "v2.3.0",
  dependencies = {
    { 'kkharji/sqlite.lua' },
    { 'nvim-telescope/telescope.nvim' },
    { 'stevearc/dressing.nvim' }, -- optional: better UI
  },
  config = function()
    -- local opts = {} -- check the "./lua/bookmarks/default-config.lua" file for all the options
    local opts = {
      -- keymap = {
      -- { '<leader>bc', '<cmd>BookmarksCommands<cr>', desc = 'Bookmarks Commands' },
      -- { '<leader>bm', '<cmd>BookmarksMark<cr>', desc = 'Toggle Bookmark' },
      -- { '<leader>bg', '<cmd>BookmarksGoto<cr>', desc = 'Goto Bookmarks' },
      -- { '<leader>bn', '<cmd>BookmarksNewList<cr>', desc = 'New Bookmarks List' },
      -- { '<leader>bl', '<cmd>BookmarksList<cr>', desc = 'Choose Bookmarks List' },
      -- },
    }
    require('bookmarks').setup(opts) -- you must call setup to init sqlite db
  end,
  vim.keymap.set('n', '<leader>bc', ':BookmarksCommands<CR>', { desc = 'Bookmarks Commands' }),
  vim.keymap.set('n', '<leader>bm', ':BookmarksMark<CR>', { desc = 'Toggle Bookmark' }),
  vim.keymap.set('n', '<leader>bg', ':BookmarksGoto<CR>', { desc = 'Goto Bookmarks' }),
  vim.keymap.set('n', '<leader>bn', ':BookmarksNewList<CR>', { desc = 'New Bookmarks List' }),
  vim.keymap.set('n', '<leader>bl', ':BookmarksLists<CR>', { desc = 'Choose Bookmarks List' }),
  vim.keymap.set('n', '<leader>bt', ':BookmarksTree<CR>', { desc = 'Toggle Bookmarks Tree' }),
}

-- run :BookmarksInfo to see the running status of the plugin
