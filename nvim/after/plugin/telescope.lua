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
    file_ignore_patterns = {
     "build", ".git/", ".cache", "%.o", "%.a", "%.out", ".idea/", ".vscode/", "%.pdf", "%.png", "%.jpg", "%.mp4", "%.mkv", "%.mp3", "%.mp4", "%.zip", "dist"
    },
  },
  -- taken from https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#change-directory 
  pickers = {
    find_files = {
      mappings = {
        n = {
          ["cd"] = function(prompt_bufnr)
            local selection = require("telescope.actions.state").get_selected_entry()
            local dir = vim.fn.fnamemodify(selection.path, ":p:h")
            require("telescope.actions").close(prompt_bufnr)
            -- Depending on what you want put `cd`, `lcd`, `tcd`
            vim.cmd(string.format("silent lcd %s", dir))
          end
        }
      }
    },
  }
}
telescope.load_extension('fzf')

vim.api.nvim_set_keymap('n', 'ff', ':Telescope find_files<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'fg', ':Telescope live_grep<CR>', { noremap = true, silent = true })

