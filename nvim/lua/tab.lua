-- tabs settings

-- tab labels settings (show tab numbers and file extension based emojis)
vim.opt.showtabline = 2 -- always show tabs in gvim

-- TODO: figure out how to scroll efficiently when there are over 20 tabs
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

