-- smart fzf + ripgrep ported by telescope
local telescope = require('telescope')
local actions = require('telescope.actions')
local lga_actions = require("telescope-live-grep-args.actions")

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
  extensions = {
    live_grep_args = {
      auto_quoting = true,
      mappings = {
        i = {
          ["<C-'>"] = lga_actions.quote_prompt(),
          ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
          -- freeze the current list and start a fuzzy search in the frozen list
          ["<C-space>"] = lga_actions.to_fuzzy_refine,
        },
      },
    }
  }
}

telescope.load_extension('fzf')
telescope.load_extension("live_grep_args")

vim.api.nvim_set_keymap('n', 'ff', ':Telescope find_files<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', 'fg', ':Telescope live_grep<CR>', { noremap = true, silent = true })
-- Upgraded version of live grep (regex supported):
--    Usage                                 Effect
--    =======================================================================
--    foo bar              	             search for „foo bar“
--    "foo bar" baz 	 	             search for „foo bar“ in dir „baz“
--    --no-ignore "foo bar 	 	         search for „foo bar“ ignoring ignores
--    "foo" --iglob **/test/** 	         search for „foo“ in any „test“ path 	
--    "foo" ../other-project 	       	 search for „foo“ in ../other-project
vim.api.nvim_set_keymap('n', 'fg', ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", {noremap = true, silent = true })
vim.api.nvim_set_keymap('n', ';;', ':Telescope lsp_document_symbols<CR>', { noremap = true, silent = true })

