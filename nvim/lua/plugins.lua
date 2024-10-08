local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Install your plugins here
return packer.startup(function(use)
    use("wbthomason/packer.nvim") -- Have packer manage itself	

    use('ellisonleao/gruvbox.nvim') -- epic color scheme

    -- Basic LSP tooling
    use('neovim/nvim-lspconfig') -- Configurations for Nvim LSP

    -- Completion framework:
    use('hrsh7th/nvim-cmp')
    use('hrsh7th/cmp-nvim-lsp')


    -- Useful completion sources:
    use('hrsh7th/cmp-nvim-lua')
    use('hrsh7th/cmp-nvim-lsp-signature-help')
    use('hrsh7th/cmp-vsnip')
    use('hrsh7th/cmp-path') 
    use('hrsh7th/cmp-buffer')
    use('hrsh7th/vim-vsnip')

    -- Fuzzy Finder (Telescope)
    use {
        'nvim-telescope/telescope.nvim', 
        requires = { {'nvim-lua/plenary.nvim'} }
    }
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    
    -- Treesitter for better syntax highlighting and code navigation
    use {
	'nvim-treesitter/nvim-treesitter',
	run = ':TSUpdate'
    }

    if PACKER_BOOTSTRAP then
	require("packer").sync()
    end
end)
