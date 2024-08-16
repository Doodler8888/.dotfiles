vim.o.clipboard = "unnamedplus"

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backupdir = "/tmp/nvim-backup//"
vim.opt.backup = true

vim.opt.undodir = "/tmp/nvim-undo//"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.signcolumn = "auto"
vim.opt.shiftwidth = 2

-- Disable 'scrolloff' when using 'H' and 'L'
vim.opt.scrolloff = 8
vim.api.nvim_set_keymap("n", "H", ":set scrolloff=0<CR>H:set scrolloff=8<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "L", ":set scrolloff=0<CR>L:set scrolloff=8<CR>", { noremap = true })

vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50

vim.opt.termguicolors = true
vim.opt.conceallevel = 0

vim.opt.shada = "'20,<50,s10,h"
vim.cmd([[
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
]])

vim.opt.textwidth = 80
vim.opt.formatoptions:append("cq")

--  Prevent auto commenting on new lines
vim.cmd([[autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o]])

-- -- Folding autosave (the setting causing bug(?) where it switches the current directory to nvim where i open .bashrc)
vim.cmd([[ set viewoptions=folds,cursor ]])
vim.cmd([[ autocmd BufWinLeave * silent! mkview ]])
vim.cmd([[ autocmd BufWinEnter * silent! loadview ]])

-- vim.g.codeium_no_map_tab = 1

vim.cmd([[
  command! StopAllLSP lua for _, client in ipairs(vim.lsp.get_active_clients()) do vim.lsp.stop_client(client) end
]])

-- vim.cmd([[ set statusline=%f\ %{winnr()} ]])
vim.api.nvim_set_option('statusline', '%{winnr()} %f')

vim.opt.completeopt = { "menuone", "noselect", "noinsert" }

vim.cmd([[ set wildmode=longest:full ]])

