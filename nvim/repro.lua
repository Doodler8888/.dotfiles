vim.g.mapleader = " "

require("vim._extui").enable({ enable = true, msg = { target = "msg" } })

vim.pack.add({
  "https://github.com/simifalaye/minibuffer.nvim",
})

local minibuffer = require("minibuffer")

vim.ui.select = require("minibuffer.builtin.ui_select")
vim.ui.input = require("minibuffer.builtin.ui_input")

vim.keymap.set("n", "<M-;>", require("minibuffer.builtin.cmdline"))
vim.keymap.set("n", "<M-.>", function()
  minibuffer.resume(true)
end)

-- vim.g.mapleader = " "
--
-- vim.pack.add({
--   "https://github.com/nvim-lua/plenary.nvim",
--   "https://github.com/nvim-telescope/telescope.nvim",
-- })
--
-- require("telescope").setup {}
--
-- vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files)
