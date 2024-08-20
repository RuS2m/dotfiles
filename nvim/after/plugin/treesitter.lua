-- Smart parser ported by treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "lua", "vim", "rust", "python" }, -- Install all maintained parsers
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
