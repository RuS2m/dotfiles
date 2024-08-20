-- color scheme settings ported from gruvbox plugin
require("gruvbox").setup({
    terminal_colors = true,
    invert_tabline = true,
})

vim.o.background = "dark" -- apply dark theme
vim.cmd("colorscheme gruvbox") -- apply gruvbox colorscheme

