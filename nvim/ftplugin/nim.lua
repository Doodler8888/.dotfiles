vim.lsp.start({
  cmd = { "nimlsp" },
  filetypes = { 'nim' },
  -- root_dir = vim.fs.dirname(vim.fs.find({'src'}, { upward = true })[1]),
})
