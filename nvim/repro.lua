-- Define the root path
local root = vim.fn.stdpath('data') -- This sets root to the standard data directory for Neovim

-- Bootstrap lazy.nvim
local lazypath = root .. "/plugins/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.runtimepath:prepend(lazypath)

-- Install hop.nvim
local plugins = {
  { "smoka7/hop.nvim", opts = {} },
}
require("lazy").setup(plugins, {})

vim.api.nvim_set_keymap('n', '/', ":HopChar1<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '/', ":HopChar1<CR>", { noremap = true, silent = true })
