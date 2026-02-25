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

-- Note: due to the mini-tabs behavior with introduction of persisting tabs, buffers need to be forcefully cleaned up
vim.keymap.set('n', 'tw', function()
  local bufnr = vim.api.nvim_get_current_buf()
  pcall(vim.cmd, 'tabclose')
  -- delete the buffer 
  if vim.api.nvim_buf_is_valid(bufnr) then
    pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
  end
end, { desc = 'Close tab and delete buffer' })

