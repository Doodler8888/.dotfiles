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
	-- "nvim-lua/plenary.nvim",
	-- "nvim-tree/nvim-web-devicons",
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		-- or                              , branch = '0.1.x',
		-- dependencies = { 'nvim-lua/plenary.nvim' }
	},
	"rose-pine/neovim",
	-- 'dhruvasagar/vim-buffer-history',
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
-- 	{
--   "NeogitOrg/neogit",
--   dependencies = {
--     "nvim-lua/plenary.nvim",         -- required
--     "sindrets/diffview.nvim",        -- optional - Diff integration
--
--     "nvim-telescope/telescope.nvim", -- optional
--     -- "echasnovski/mini.pick",         -- optional
--   },
--   config = true
-- },
	{
		"windwp/nvim-autopairs",
		bvent = "InsertEnter",
		opts = {}, -- this is equalent to setup({}) function
	},
	'tpope/vim-fugitive',
	-- 'stevearc/oil.nvim',
	'justinmk/vim-dirvish', -- use tpope/vim-eunuch with the plugin
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
-- {
--     "vhyrro/luarocks.nvim",
--     priority = 1001, -- this plugin needs to run before anything else
--     opts = {
--         rocks = { "magick" },
--     },
-- },
-- {
--     "3rd/image.nvim",
--     dependencies = { "luarocks.nvim" },
--     opts = {}
-- },
	{
		'echasnovski/mini.nvim',
		config = function()
			require("mini.ai").setup({
			})
			require("mini.bracketed").setup({
			})
			-- require("mini.files").setup({
			-- 	mappings = {
			-- 		close       = 'q',
			-- 		go_in       = '<CR>',
			-- 		go_in_plus  = 'L',
			-- 		go_out      = '-',
			-- 		go_out_plus = 'H',
			-- 		mark_goto   = "'",
			-- 		mark_set    = 'm',
			-- 		reset       = '<BS>',
			-- 		reveal_cwd  = '@',
			-- 		show_help   = 'g?',
			-- 		synchronize = '=',
			-- 		trim_left   = '<',
			-- 		trim_right  = '>',
			-- 	},
			-- })
  -- 	require("mini.files").setup({
  -- -- Module mappings created only inside explorer.
  -- -- Use `''` (empty string) to not create one.
  -- mappings = {
  --  close       = 'q',
  --  go_in       = 'L',
  --  go_in_plus  = '<CR>',
  --  go_out      = '-',
  --  go_out_plus = 'H',
  --  mark_goto   = "'",
  --  mark_set    = 'm',
  --  reset       = '<BS>',
  --  reveal_cwd  = '@',
  --  show_help   = 'g?',
  --  synchronize = '=',
  --  trim_left   = '<',
  --  trim_right  = '>',
  -- },
			-- })
			-- require("mini.surround").setup({
			-- })
		end,
	},
	'mbbill/undotree',
	-- {
	-- 'smilhey/ed-cmd.nvim',
	-- 	config = function()
	--  vim.opt.guicursor = "n-v:block,i-ci-c-ve:ver25,r-cr:hor20,o:hor50"
	-- 		require("ed-cmd").setup({
	-- 			keymaps = { edit = "<ESC>", execute = "<CR>", close = "<C-g>" },
	-- 		})
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
	'hrsh7th/cmp-nvim-lsp',
	'hrsh7th/cmp-buffer',
	'hrsh7th/cmp-path',
	'hrsh7th/cmp-cmdline',
	'hrsh7th/nvim-cmp',
	-- {
	-- 	'saghen/blink.cmp',
	-- 	dependencies = 'rafamadriz/friendly-snippets',
	-- 	version = 'v0.*',
	-- 	opts = {
	-- 		keymap = {
	-- 			preset = 'default',
	-- 			-- ['<C-y>'] = {},
	-- 			['<Tab>'] = {
	-- 				function(cmp)
	-- 					if cmp.is_visible() then
	-- 						return cmp.accept()
	-- 					else
	-- 						cmp.show()
	-- 						return true
	-- 					end
	-- 				end,
	-- 				'fallback'
	-- 			},
	-- 		},
	-- 		appearance = {
	-- 			use_nvim_cmp_as_default = true,
	-- 			nerd_font_variant = 'mono'
	-- 		},
	-- 		signature = { enabled = true },
	-- 		completion = {
	-- 			menu = {
	-- 				auto_show = false
	-- 			},
	-- 			ghost_text = {
	-- 				enabled = false
	-- 			}
	-- 		}
	-- 	},
	-- },
}

require("lazy").setup(plugins, opts)
