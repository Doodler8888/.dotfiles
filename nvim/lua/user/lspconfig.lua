local on_attach = function(client, bufnr)
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_buf_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("LspFormatting" .. bufnr, { clear = true }),
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ bufnr = bufnr })
      end,
    })
  end
end

-- 2. Configure the lua_ls server using `vim.lsp.config` and pass `on_attach` directly
vim.lsp.config("lua_ls", {
  on_attach = on_attach, -- <--- Pass the on_attach function here
  cmd = { "lua-language-server" },
  settings = {
    Lua = {
      runtime = {
	version = 'LuaJIT',
	path = vim.split(package.path, ';'),
      },
      diagnostics = {
	globals = {'vim', 'opts'},
      },
      workspace = {
	library = {
	  [vim.fn.expand('$VIMRUNTIME/lua')] = true,
	  [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
	},
      },
    },
  },
})

vim.lsp.config("pyright", {
  on_attach = on_attach,
})
