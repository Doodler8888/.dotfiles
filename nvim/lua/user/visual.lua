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


vim.opt.tabline = "%!v:lua.MyTabLine()"

function _G.MyTabLine()
  local s = ''
  for i = 1, vim.fn.tabpagenr('$') do
    local tabnr = i
    local buflist = vim.fn.tabpagebuflist(tabnr)
    local winnr = vim.fn.tabpagewinnr(tabnr)
    local bufnr = buflist[winnr]
    local bufname = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ':t')
    local bufdir = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ':h')
    local dirparts = vim.split(bufdir, '/', true)
    local dirinfo = ''
    if #dirparts >= 2 then
      dirinfo = string.sub(dirparts[#dirparts - 1], 1, 1) .. '/' .. string.sub(dirparts[#dirparts], 1, 1) .. '/'
    elseif #dirparts == 1 and dirparts[1] ~= '' then
      dirinfo = string.sub(dirparts[1], 1, 1) .. '/'
    end

    s = s .. '%' .. tabnr .. 'T'
    s = s .. (tabnr == vim.fn.tabpagenr() and '%#TabLineSel#' or '%#TabLine#')
    s = s .. ' ' .. dirinfo .. bufname .. ' '
  end
  s = s .. '%#TabLineFill#%T'
  return s
end
