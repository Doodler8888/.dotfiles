-- 1. Create separate 'nvim-repro' config directory:
--     - '~/.config/nvim-repro/'
--
-- 2. Launch neovim with `NVIM_APPNAME=nvim-repro nvim`.

-- Bootstrap lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set up lazy.nvim to load only nvim-autopairs
require("lazy").setup({
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup{}
    end,
  },
})
