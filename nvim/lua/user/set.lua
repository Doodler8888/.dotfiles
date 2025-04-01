vim.o.clipboard = "unnamedplus"

vim.o.cursorline = false

vim.opt.nu = true -- 'nu' is probably short for 'number'
vim.opt.relativenumber = true

vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backupdir = "/tmp/nvim-backup//"
vim.opt.backup = true

-- vim.opt.undodir = "/tmp/nvim-undo//"
-- local home = os.getenv("HOME")
-- vim.opt.undodir = home .. "/.var/nvim-undo/"
vim.opt.undodir = "/home/wurfkreuz/.var/nvim-undo/"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.signcolumn = "auto"
vim.opt.shiftwidth = 4

-- Disable 'scrolloff' when using 'H' and 'L'
vim.opt.scrolloff = 8
vim.api.nvim_set_keymap("n", "H", ":set scrolloff=0<CR>H:set scrolloff=8<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "L", ":set scrolloff=0<CR>L:set scrolloff=8<CR>", { noremap = true })

vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50

vim.opt.termguicolors = true
-- vim.opt.conceallevel = 0
vim.opt.conceallevel = 2
-- vim.opt.concealcursor = "nc"

vim.opt.autowrite = true
vim.opt.autowriteall = true

vim.opt.shada = "'20,<50,s10,h"
vim.cmd([[
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
]])

vim.opt.textwidth = 80
vim.opt.formatoptions:append("cq")

--  Prevent auto commenting on new lines
vim.cmd([[autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o]])

-- Treesitter folding (it autofolds on launch, that's why i don't use it)
-- vim.wo.foldmethod = 'expr'
-- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

-- This code break folding
-- -- Folding autosave (the setting causing bug(?) where it switches the current directory to nvim where i open .bashrc)
-- vim.cmd([[ set viewoptions=folds,cursor ]])
-- vim.cmd([[ autocmd BufWinLeave * silent! mkview ]])
-- vim.cmd([[ autocmd BufWinEnter * silent! loadview ]])

-- For tmux <escape> latency
vim.o.timeoutlen = 1000
vim.o.ttimeoutlen = 0

vim.cmd([[ set wildmode=longest:full ]])
-- vim.opt.completeopt = { "menuone", "noselect", "noinsert" }
vim.opt.completeopt = { "menuone", "noselect", "popup", "fuzzy" }

vim.diagnostic.config({
  signs = false,
  underline = false,
  -- virtual_lines = true  -- Enables lsp diagnostics representation like in helix, but i need to pull from master first.
})

-- Cursor is always a pipe (I set it, because the bursor behavior is
-- inconsistent in cmdline. Sometimes it's a block, sometimes it's a pipe and i
-- dont' like it.)
vim.opt.guicursor = "n-v:block,i-ci-c-ve:ver25,r-cr:hor20,o:hor50"

vim.g.netrw_banner = 0
-- vim.g.netrw_trash = 1

-- I can't change this, because it fucks up highlighting
-- vim.cmd([[ set iskeyword-=_ ]])

-- new option
-- vim.o.winborder = 'rounded'

-- I set it as auto-revert
vim.o.autoread = true
