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


-- If i put it to visual.lua or rosepine.lua, it wont work
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#17191a" })


vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
  callback = function()
    local lnum = vim.fn.line(".")
    local col = vim.fn.col(".")
    local concealed = vim.fn.synconcealed(lnum, col) ~= 0
    if concealed and vim.wo.concealcursor ~= "" then
      vim.wo.concealcursor = ""
    elseif not concealed and vim.wo.concealcursor ~= "nc" then
      vim.wo.concealcursor = "nc"
    end
  end,
})
