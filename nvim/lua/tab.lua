-- tabs settings
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

