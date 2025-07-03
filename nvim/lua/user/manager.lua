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
	-- "nvim-tree/nvim-tree.lua",
	-- "tpope/vim-fugitive",
	'Doodler8888/resession.nvim',
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		-- event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},
	-- {
	-- 	"windwp/nvim-autopairs", -- This pluging causes a bug if i try to press enter before triple backticks to move markdown code block one line down. It creates 2 newlines in this case.
	-- 	bvent = "InsertEnter",
	-- 	opts = {}, -- this is equalent to setup({}) function
	-- },
	-- 'justinmk/vim-dirvish',
	{
	    "stevearc/oil.nvim",
	    branch = "master",
	    pin = true  -- prevents auto-updates
	},
	{
		"neovim/nvim-lspconfig",
	},
	{
	  'stevearc/quicker.nvim',
	  event = "FileType qf",
	  ---@module "quicker"
	  ---@type quicker.SetupOptions
	  opts = {},
	},
{
  "tadmccorkle/markdown.nvim",
  -- ft = "markdown", -- or 'event = "VeryLazy"'
  -- opts = {
  --   -- configuration here or empty for defaults
  -- },
},
	{
		'echasnovski/mini.nvim',
		branch = 'main',
		config = function()
			require("mini.pairs").setup({
			})
			-- require("mini.completion").setup({
			-- })
			-- require("mini.ai").setup({
			-- })
			-- require("mini.bracketed").setup({
			-- })
		end,
	},
	{
	    'numToStr/Comment.nvim',
	    opts = {},
	    lazy = false,
	},
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
	'saadparwaiz1/cmp_luasnip',
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
