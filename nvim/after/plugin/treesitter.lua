-- Smart parser ported by treesitter
require'nvim-treesitter.config'.setup {
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "rust", "python", "cpp", "xml", "json" }, -- Install all maintained parsers
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,                -- false will disable the whole extension
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true
  },
}
