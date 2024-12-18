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
	"ibhagwan/fzf-lua",
	"stevearc/oil.nvim",
	"stevearc/conform.nvim",
	'Raku/vim-raku',
	{
	  "NeogitOrg/neogit",
	  dependencies = {
	    "nvim-lua/plenary.nvim",
	    "sindrets/diffview.nvim",        -- optional - Diff integration
	  },
	},
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
	'Doodler8888/resession.nvim',
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
		"neovim/nvim-lspconfig",
	},
	'mbbill/undotree',
	'mfussenegger/nvim-lint',
	'tpope/vim-fugitive',
	'jvgrootveld/telescope-zoxide',
	-- {
	-- 	"yorickpeterse/nvim-tree-pairs", -- It breask how the % binding works
	-- 	config = function()
	-- 	  require('tree-pairs').setup()
	-- 	end,
	-- },
	{
	  "nvim-treesitter/nvim-treesitter",
	  config = function()
	    -- setup treesitter with config
	  end,
	  -- dependencies = {
	  --   -- note: additional parser
	  --   { "nushell/tree-sitter-nu" },
	  -- },
	  build = ":TSUpdate",
	},
	'nvim-treesitter/nvim-treesitter-textobjects',
	-- {
	--   "vhyrro/luarocks.nvim",
	--   priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
	--   config = true,
	-- },
	"folke/flash.nvim",
	-- {
	--   "nvim-neorg/neorg",
	--   lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
	--   version = "*", -- Pin Neorg to the latest stable release
	--   config = true,
	-- },
	-- ,
	-- {
	--   "OXY2DEV/markview.nvim",
	--   lazy = false,      -- Recommended
	-- },
	'pocco81/auto-save.nvim',
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
	'saadparwaiz1/cmp_luasnip',
	'hrsh7th/cmp-cmdline',
	'hrsh7th/cmp-buffer',
	'hrsh7th/cmp-path',
	'hrsh7th/cmp-nvim-lsp',
	-- 'PaterJason/cmp-conjure',
}

require("lazy").setup(plugins, opts)
