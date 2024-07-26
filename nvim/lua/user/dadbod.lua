-- This is the key setting to disable folding
vim.api.nvim_create_autocmd("FileType", {
  pattern = "dbout",
  callback = function()
    vim.cmd("normal zR")
  end,
})
