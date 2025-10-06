vim.g.mapleader = " "

vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-telescope/telescope.nvim",
})

require("telescope").setup {}

vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files)
