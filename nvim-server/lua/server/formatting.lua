vim.opt.textwidth = 80

-- Disable formatting while typing
vim.opt.formatoptions:remove({ "c", "q" })

-- These commands will install autocommands to add and remove the format options when entering and leaving insert mode.
vim.api.nvim_exec([[
  augroup MyFormatOptions
    autocmd!
    autocmd BufEnter * setlocal formatoptions+=cq
    autocmd BufLeave * setlocal formatoptions-=cq
  augroup END
]], false)
