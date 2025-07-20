vim.filetype.add({
  pattern = {
    [".*/templates/.*%.yaml"] = "helm",
    [".*/templates/.*%.yml"] = "helm",
  },
})

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "helm",
--   callback = function()
--     vim.bo.commentstring = "{{/* %s */}}"
--   end
-- })


require("core.lsp")
require("core.snippet")

require("user")


local bufhist = require("user.buffer_history")
vim.keymap.set("n", "<C-Tab>", function() bufhist.jump(-1) end, { noremap = true, silent = true })
vim.keymap.set("n", "<S-Tab>", function() bufhist.jump(1)  end, { noremap = true, silent = true })


vim.api.nvim_create_autocmd("BufWinEnter", {
  callback = function()
    local buf = vim.fn.bufnr()
    require("user.buffer_history").add(buf)
  end,
})

-- If i put it to visual.lua or rosepine.lua, it wont work
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#17191a" })
vim.api.nvim_set_hl(0, "DirvishSuffix", { fg = "#6e6a86" })


-- function FormatFilePath()
--     local full_path = vim.fn.expand('%:p')
--     local home_dir = vim.fn.expand('$HOME')
--     full_path = full_path:gsub('^' .. home_dir, '~')
--     return full_path
-- end
--
-- -- Update your statusline to use the plugin's function
-- vim.o.statusline = '%{winnr()} %{%v:lua.FormatFilePath()%} %{gitbranch#name() != "" ? "[" . gitbranch#name() . "]" : ""}'


vim.g.vim_markdown_new_list_item_indent = 2
vim.g.vim_markdown_folding_disabled = 1

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    -- Completely override folding behavior
    vim.opt_local.foldenable = false
    vim.opt_local.foldmethod = "manual"
    vim.opt_local.foldexpr = ""
  end,
})
