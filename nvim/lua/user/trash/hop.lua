require('hop').setup({
})

vim.api.nvim_set_keymap('n', '/', ":HopChar1<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '/', ":HopChar1<CR>", { noremap = true, silent = true })
