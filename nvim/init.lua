require("plugins")

-- Plugin-related settings
-------------------------------------------------------------------

-- color scheme settings:
vim.o.background = "dark" -- apply dark theme
require("gruvbox").setup({invert_tabline = true})
vim.cmd("colorscheme gruvbox") -- apply gruvbox colorscheme

-- LSP-related settings:
require("mason").setup({
    ui = {
        icons = {
            package_installed = "",
            package_pending = "",
            package_uninstalled = "",
        },
    }
})
require("mason-lspconfig").setup()

-- Rust analyzer settings:
-- don't forget to run :MasonInstall rust-analyzer codelldb
local rt = require("rust-tools")

rt.setup({
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
})

--====================================================--
--------------------------------------------------------

-- default settings:
--------------------------------------------------------
vim.opt.exrc = true -- automatically execute .nvim.lua, .nvimrc and .exrc files in the current directory

vim.opt.encoding = "utf-8" -- required by autocomplete

vim.opt.tabstop = 4 -- interpret tabs as 4 spaces
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.number = true -- show numbers 
vim.opt.relativenumber = true

vim.opt.colorcolumn = "156" -- prevent myself from typing too long lines of code or text
vim.cmd([[highlight ColorColumn ctermbg=darkgray]])

-- tabs settings:
--------------------------------------------------------

-- tab labels settings (show tab numbers and file extension based emojis)
vim.opt.showtabline = 2 -- always show tabs in gvim

function custom_tab_line()
    local tabline = ''

    -- iterating over tabpages
    for index = 1, vim.fn.tabpagenr('$') do
        -- select the highlighting
        if index == vim.fn.tabpagenr() then
            tabline = tabline .. '%#TabLineSel#'
        else
            tabline = tabline .. '%#TabLine#'
        end

        -- getting buffer name
        local win_num = vim.fn.tabpagewinnr(index) -- get window number for tabpage
        local bufnrlist = vim.fn.tabpagebuflist(index) -- get buffers for the tabpage
        local bufnr = bufnrlist[win_num - 0] -- get buffer for the window number
        local bufname = vim.fn.bufname(bufnr) -- get buffer name for buffer number

        -- constructing new tabline
        local pathname = bufname:gsub("([^/]+)/", function(s) return s:sub(1, 1) .. '/' end) -- take first element of every part of the path beside last
        
        -- type of the file matching
        emoji = "📄"
        if pathname:match("%.c") then
            emoji = "©️ "
        elseif pathname:match("%.cpp") then
            emoji = "🐀"
        elseif pathname:match("%.html") then
            emoji = "🌐"
        elseif pathname:match("%.java") then
            emoji = "☕"
        elseif pathname:match("%.json") then
            emoji = "📦"
        elseif pathname:match("%.lua$") then
            emoji = "🌚"
        elseif pathname:match("%.py") then
            emoji = "🐍"
        elseif pathname:match("%.rs$") then
            emoji = "🦀"
        end

        tabline = tabline .. " " .. emoji .. " " .. pathname .. " [" .. index .. "] "
    end

    -- after the last tab fill with TabLineFill and reset tab page nr
    tabline = tabline .. '%#TabLineFill#%T'

    -- right-align the label to close the current tab page
    if vim.fn.tabpagenr('$') > 1 then
        tabline = tabline .. '%=%#TabLine#%999Xclose'
    end

    return tabline
end

vim.go.tabline = "%!v:lua.custom_tab_line()"

-- tab navigation settings (get to tab, by typing number + `]`; `t[` -- previous tab, `t]` -- next tab, `tn` -- new tab, `tw` -- close tab)
for i=1,10,1 do
    vim.api.nvim_set_keymap(
        "n",
        i .. "]",
        i .. "gt<cr>",
        { noremap = true }
    )
end

vim.api.nvim_set_keymap(
    "n",
    "t]",
    ":tabnext<cr>",
    { noremap = true }
)

vim.api.nvim_set_keymap(
    "n",
    "t[",
    ":tabprev<cr>",
    { noremap = true }
)

vim.api.nvim_set_keymap(
    "n",
    "tt",
    ":tabnew<cr>",
    { noremap = true }
)

vim.api.nvim_set_keymap(
    "n",
    "tw",
    ":tabclose<cr>",
    { noremap = true }
)

-- file navigation settings:
--------------------------------------------------------

-- netrw :Lexplore shortcut as 
vim.api.nvim_set_keymap(
    "n",
    "ff",
    ":tabnew<cr>:Lexplore<cr>",
    { noremap = true }
)

-- LSP and autocomplete settings:
--------------------------------------------------------

-- LSP diagnostics setup
local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ''
  })
end

sign({name = 'DiagnosticSignError', text = ''})
sign({name = 'DiagnosticSignWarn', text = ''})
sign({name = 'DiagnosticSignHint', text = ''})
sign({name = 'DiagnosticSignInfo', text = ''})

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = false,
    float = {
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})

vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

-- Completion Plugin Setup
local cmp = require'cmp'
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },
  -- Installed sources:
  sources = {
    { name = 'path' },                              -- file paths
    { name = 'nvim_lsp', keyword_length = 3 },      -- from language server
    { name = 'nvim_lsp_signature_help'},            -- display function signatures with current parameter emphasized
    { name = 'nvim_lua', keyword_length = 2},       -- complete neovim's Lua runtime API such vim.lsp.*
    { name = 'buffer', keyword_length = 2 },        -- source current buffer
    { name = 'vsnip', keyword_length = 2 },         -- nvim-cmp source for vim-vsnip 
    { name = 'calc'},                               -- source for math calculation
  },
  window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
  },
  formatting = {
      fields = {'menu', 'abbr', 'kind'},
      format = function(entry, item)
          local menu_icon ={
              nvim_lsp = 'λ',
              vsnip = '⋗',
              buffer = 'Ω',
              path = '🖫',
          }
          item.menu = menu_icon[entry.source.name]
          return item
      end,
  },
})

-- Lamguage-specific settings
--------------------------------------------------------


-- Rust 🦀
--------------------------------------------------------

-- Rust analyzer settings:

-- Control + E to open the macro expansion in the next window
vim.api.nvim_set_keymap(
    "n",
    "C-e",
    ":RustExpandMacro<cr>",
    { noremap = true }
)

-- commands:
-- -----------------------------------------------------
--
-- autocomplete:
-- ======================
-- ctrl+E                                               show Rust macro expansion in the different window
-- ctrl+C                                               hover actions (show analyzer hints)
-- Tab                                                  next hint
-- S-Tab                                                previous hint 
--
-- netrw
-- ======================
-- ctrl+W + arrow                                       switch back to the tree window
-- ff                                                   launch :Lexplore (tree window with lookup) in the new tab
--
-- vim tabs modified
-- ======================
-- number + ]                                           go to tab with specified number (numbers are showed as part of the tabpage labels)
-- t + ]                                                go to the next tab
-- t + [                                                go to the previous tab
-- tw                                                   close the tab
-- :tabonly                                             close all tabs besides current
-- :tabfind [name]                                      find a file and open it in new tab

-- by RuS2m

