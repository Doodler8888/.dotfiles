require("persistence").setup({})

local function delayed_load_session()
  vim.defer_fn(function()
    require("persistence").load()
  end, 25)
end

vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  callback = delayed_load_session
})

-- restore the session for the current directory
vim.api.nvim_set_keymap("n", "<leader>qs", [[<cmd>lua require("persistence").load()<cr>]], {})

-- restore the last session
vim.api.nvim_set_keymap("n", "<leader>ql", [[<cmd>lua require("persistence").load({ last = true })<cr>]], {})

-- stop Persistence => session won't be saved on exit
vim.api.nvim_set_keymap("n", "<leader>qd", [[<cmd>lua require("persistence").stop()<cr>]], {})
