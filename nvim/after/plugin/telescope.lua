-- smart fzf + ripgrep ported by telescope
local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.setup{
  defaults = {
    mappings = {
      i = {
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
    },
  },
}
telescope.load_extension('fzf')

vim.api.nvim_set_keymap('n', 'ff', ':Telescope find_files<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'fg', ':Telescope live_grep<CR>', { noremap = true, silent = true })

