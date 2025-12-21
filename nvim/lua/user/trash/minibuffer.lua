local minibuffer = require("minibuffer")
vim.g.mapleader = " "

vim.ui.select = require("minibuffer.builtin.ui_select")
vim.ui.input = require("minibuffer.builtin.ui_input")

vim.keymap.set("n", "<leader>ff", require("minibuffer.examples.files"))
vim.keymap.set("n", "<leader>fb", require("minibuffer.examples.buffers"))

vim.keymap.set("n", "<M-;>", require("minibuffer.builtin.cmdline"))
vim.keymap.set("n", "<M-.>", function()
  minibuffer.resume(true)
end)
