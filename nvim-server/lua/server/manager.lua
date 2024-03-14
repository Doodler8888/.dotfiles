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
	'nvim-lua/plenary.nvim',
	{
	  'nvim-telescope/telescope.nvim', tag = '0.1.5',
	  -- or                              , branch = '0.1.x',
	  dependencies = { 'nvim-lua/plenary.nvim' }
	},
	'rose-pine/neovim',
	{
	 'numToStr/Comment.nvim',
	 opts = {
	  -- add any options here
	 },
	 lazy = false,
	},
	{
	  'windwp/nvim-autopairs',
	  event = "InsertEnter",
	  opts = {} -- this is equalent to setup({}) function
	},
	{
	  "kylechui/nvim-surround",
	  version = "*", -- Use for stability; omit to use `main` branch for the latest features
	  event = "VeryLazy",
	  config = function()
	    require("nvim-surround").setup({
	      -- Configuration here, or leave empty to use defaults
	    })
	  end
	},
	{
	 'neovim/nvim-lspconfig',
	  -- opts = {
	  --   servers = {
	  --     nushell = {},
	  --     -- other config
	  --   },
	  -- },
	},
	 'hashivim/vim-terraform',
	 'dense-analysis/ale',
	 'pocco81/auto-save.nvim',
}

require("lazy").setup(plugins, opts)
