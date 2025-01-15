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
	"rose-pine/neovim",
	-- "itspriddle/vim-shellcheck",
	-- "anuvyklack/hydra.nvim",
	-- "stevearc/conform.nvim",
	-- {
	--   'kristijanhusak/vim-dadbod-ui',
	--   dependencies = {
	--     { 'tpope/vim-dadbod', lazy = true },
	--     { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql', 'psql' }, lazy = true },
	--   },
	--   cmd = {
	--     'DBUI',
	--     'DBUIToggle',
	--     'DBUIAddConnection',
	--     'DBUIFindBuffer',
	--   },
	--   init = function()
	--     -- Your DBUI configuration
	--     vim.g.db_ui_use_nerd_fonts = 1
	--   end,
	-- },
	'Doodler8888/resession.nvim',
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
		bvent = "InsertEnter",
		opts = {}, -- this is equalent to setup({}) function
	},
	-- {
	-- 	"neovim/nvim-lspconfig",
	-- },
	{
	  'stevearc/quicker.nvim',
	  event = "FileType qf",
	  ---@module "quicker"
	  ---@type quicker.SetupOptions
	  opts = {},
	},
	-- 'mbbill/undotree',
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
	"folke/flash.nvim",
}

require("lazy").setup(plugins, opts)
