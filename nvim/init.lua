require("core.lsp")
require("core.snippet")

require("user")

-- local bufhist = require("user.buffer_history")
-- vim.keymap.set("n", "<C-Tab>", function() bufhist.jump(-1) end, { noremap = true, silent = true })
-- vim.keymap.set("n", "<S-Tab>", function() bufhist.jump(1)  end, { noremap = true, silent = true })
--
--
-- vim.api.nvim_create_autocmd("BufWinEnter", {
--   callback = function()
--     local buf = vim.fn.bufnr()
--     require("user.buffer_history").add(buf)
--   end,
-- })

