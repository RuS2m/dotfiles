-- Smart parser ported by treesitter
local treesitter = require("nvim-treesitter")
-- modified treesitter setup due to a not backwards compatible change in the main api with no deprecation notice
-- https://github.com/nvim-treesitter/nvim-treesitter/discussions/8357
-- Install all maintained parsers
treesitter.install { "c", "lua", "vim", "vimdoc", "query", "rust", "python", "cpp", "xml", "json", "javascript", "python" }

vim.api.nvim_create_autocmd('FileType', {
  pattern = { "c", "lua", "vim", "vimdoc", "query", "rust", "python", "cpp", "xml", "json", "javascript", "python" },
  callback = function()
    -- syntax highlighting, provided by Neovim
    vim.treesitter.start()
    -- folds, provided by Neovim (I don't like folds)
    -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    -- vim.wo.foldmethod = 'expr'
    -- indentation, provided by nvim-treesitter
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
