vim.pack.add({
  -- Core & UI
  "https://github.com/echasnovski/mini.nvim",
  "https://github.com/rose-pine/neovim",

  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-telescope/telescope.nvim",

  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",

  "https://github.com/tpope/vim-fugitive",
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/Doodler8888/resession.nvim",
  "https://github.com/kylechui/nvim-surround",
  { src = "https://github.com/nvim-lualine/lualine.nvim", version = "master" },

  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/hrsh7th/nvim-cmp",
  "https://github.com/hrsh7th/cmp-nvim-lsp",
  "https://github.com/hrsh7th/cmp-buffer",
  "https://github.com/hrsh7th/cmp-path",
  "https://github.com/hrsh7th/cmp-cmdline",
  "https://github.com/saadparwaiz1/cmp_luasnip",
  {
    src = "https://github.com/L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
  },
})
