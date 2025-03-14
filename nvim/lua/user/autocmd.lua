vim.api.nvim_create_autocmd("CmdlineEnter", {
  pattern = "*",
  callback = function()
    vim.api.nvim_create_autocmd("CmdlineLeave", {
      pattern = "*",
      once = true,
      callback = function()
        local cmd = vim.fn.getcmdline()
        if cmd == "so" or cmd:match("^so ") then
          vim.cmd("wall")
        end
      end
    })
  end
})


-- Remove trailing whitespace on save for programming files
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = {"*.lua", "*.py", "*.cpp", "*.c", "*.h", "*.hpp", "*.js", "*.jsx", "*.ts", "*.tsx", "*.rs", "*.go", "*.java"},
    callback = function()
        local save_cursor = vim.fn.getpos(".")
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.setpos(".", save_cursor)
    end,
})


_G.source_and_trim = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd('silent! noautocmd %s/\\s\\+$//e')
    vim.fn.setpos(".", save_cursor)
    vim.cmd('source %')
    vim.fn.feedkeys(':so\r', 'nt')
end

vim.cmd([[
    cabbrev <expr> so getcmdtype() == ':' && getcmdline() == 'so' ? '<Cmd>lua source_and_trim()<CR>' : 'so'
]])
