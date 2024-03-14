vim.lsp.start({
  name = 'gopls',
  cmd = {'gopls'},
  -- filetypes = { "go", "gomod" },
  root_dir = vim.fs.dirname(vim.fs.find({ "go.mod" }, { upward = true })[1]),
})

-- local lspconfig = require('lspconfig')
--
-- lspconfig.gopls.setup {
--     on_attach = function(client, bufnr)
--         -- Format on save
--         if client.server_capabilities.documentFormattingProvider then
--             vim.api.nvim_create_autocmd("BufWritePre", {
--                 group = vim.api.nvim_create_augroup("Format", { clear = true }),
--                 buffer = bufnr,
--                 callback = function()
--                     -- Use the new formatting function
--                     vim.lsp.buf.format({
--                         timeout_ms = 1000,
--                         bufnr = bufnr
--                     })
--                 end
--             })
--         end
--     end,
-- }
