vim.api.nvim_create_autocmd("FileType", {
  pattern = "kdl",
  callback = function()
    vim.bo.commentstring = "// %s"
  end
})


vim.api.nvim_create_autocmd("FileType", {
  pattern = "org",
  callback = function()
    vim.bo.commentstring = "# %s"
  end
})
