-- Highlight, edit, and navigate code
-- main branch is a full rewrite of nvim-treesitter (master is archived/frozen and
-- explicitly unsupported on Neovim 0.12+) — see :h nvim-treesitter-commands
return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false, -- main branch does not support lazy-loading
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter').install {
      'bash',
      'c',
      'css',
      'diff',
      'dockerfile',
      'gitignore',
      'go',
      'gomod',
      'gosum',
      'html',
      'javascript',
      'json',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'php',
      'python',
      'query',
      'ssh_config',
      'sql',
      'tsx',
      'typescript',
      'vim',
      'vimdoc',
      'yaml',
      'xml',
    }

    -- Highlighting/indent are no longer enabled via opts; start them per-buffer.
    -- pcall guards filetypes with no installed parser (no per-language allowlist needed).
    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        local ok = pcall(vim.treesitter.start, args.buf)
        if ok then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
