-- Create borders for hover windows 
vim.cmd [[
highlight NormalFloat guibg=#282c34
highlight FloatBorder guifg=#ffffff guibg=#61afef
]]

vim.cmd('highlight FloatBorder  ctermfg=NONE ctermbg=NONE cterm=NONE')

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "single"
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "single"
})
