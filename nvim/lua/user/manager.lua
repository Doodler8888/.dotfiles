local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
	"nvim-lua/plenary.nvim",
	"nvim-tree/nvim-web-devicons",
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		-- or                              , branch = '0.1.x',
		-- dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
	},
	"nvim-telescope/telescope-ui-select.nvim",
	"rose-pine/neovim",
	"anuvyklack/hydra.nvim",
	"folke/flash.nvim",
	"ibhagwan/fzf-lua",
	"stevearc/oil.nvim",
	"stevearc/conform.nvim",
	-- "tpope/vim-sleuth",
	-- 'saecki/crates.nvim',
	'Raku/vim-raku',
	{
	  'kristijanhusak/vim-dadbod-ui',
	  dependencies = {
	    { 'tpope/vim-dadbod', lazy = true },
	    { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql', 'psql' }, lazy = true },
	  },
	  cmd = {
	    'DBUI',
	    'DBUIToggle',
	    'DBUIAddConnection',
	    'DBUIFindBuffer',
	  },
	  init = function()
	    -- Your DBUI configuration
	    vim.g.db_ui_use_nerd_fonts = 1
	  end,
	},
	-- 'Olical/conjure',
	'stevearc/resession.nvim',
	-- 'nvim-neorg/neorg',
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {}, -- this is equalent to setup({}) function
	},
	{
		"benlubas/wrapping-paper.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
	},
	{
		"numToStr/Comment.nvim",
		opts = {
			-- add any options here
		},
		lazy = false,
	},
	{
		"neovim/nvim-lspconfig",
	},
	'nat-418/boole.nvim',
	'mbbill/undotree',
	{
	  "nvim-treesitter/nvim-treesitter",
	  config = function()
	    -- setup treesitter with config
	  end,
	  dependencies = {
	    -- note: additional parser
	    { "nushell/tree-sitter-nu" },
	  },
	  build = ":TSUpdate",
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	"dense-analysis/ale",
	'pocco81/auto-save.nvim',
	-- {
	--   'Exafunction/codeium.vim',
	--   config = function ()
	--     vim.keymap.set('i', '<C-a>', function () return vim.fn['codeium#Accept']() end, { expr = true })
	--   end
	-- },
	"nanotee/zoxide.vim",
	{
	  "hrsh7th/nvim-cmp",
	  dependencies = {
	    {
	      'L3MON4D3/LuaSnip',
	      build = (function()
		-- Build Step is needed for regex support in snippets
		-- This step is not supported in many windows environments
		-- Remove the below condition to re-enable on windows
		if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
		  return
		end
		return 'make install_jsregexp'
	      end)(),
	    },
	  },
	},
	'hrsh7th/cmp-buffer',
	'hrsh7th/cmp-path',
	'hrsh7th/cmp-nvim-lsp',
}

require("lazy").setup(plugins, opts)
