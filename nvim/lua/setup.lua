-- default settings
vim.opt.exrc = true -- automatically execute .nvim.lua, .nvimrc and .exrc files in the current directory

vim.opt.encoding = "utf-8" -- required by autocomplete
vim.opt.mouse = "a" -- allow mouse movements

vim.opt.tabstop = 4 -- interpret tabs as 4 spaces
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.number = true -- show numbers
vim.opt.relativenumber = true

vim.opt.colorcolumn = "156" -- prevent myself from typing too long lines of code or text
vim.cmd([[highlight ColorColumn ctermbg=darkgray]])

-- override gruvbox default settings for floating box colorscheme (it sets it to purple)
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#5a524c', fg = '#ebdbb2' })
vim.api.nvim_set_hl(0, 'FloatBorder', { bg = '#5a524c', fg = '#fbf1c7' })
