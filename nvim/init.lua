-- if vim.fn.has("nvim-1.10") == 0 then
--     vim.notify("NativeVim-stable only supports Neovim 0.10+", vim.log.levels.ERROR)
--     return
-- end


require("core.options")
require("core.lsp")
require("core.snippet")

require("user")


