local resession = require("resession")
require("resession").setup({
  autosave = {
    enabled = true,
    interval = 30,
    notify = false,
  },
  options = {
    "binary",
    "bufhidden",
    "buflisted",
    "cmdheight",
    "diff",
    "filetype",
    "modifiable",
    "previewwindow",
    "readonly",
    "scrollbind",
    "winfixheight",
    "winfixwidth",
  },
  extensions = {
    oil_extension = {
      enable_in_tab = true,
      save_buffers = true,
    },
  },
})

vim.keymap.set("n", "<leader>ss", resession.save)
vim.keymap.set("n", "<leader>sl", resession.load)
vim.keymap.set("n", "<leader>sd", resession.delete)

-- vim.api.nvim_create_autocmd("VimLeavePre", {
  --   callback = function()
    --     if require('resession').is_loading() then
    --       require('resession').save()
    --     end
    --   end,
    -- })

vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    require('resession').save()
  end,
})

    -- vim.api.nvim_create_autocmd("VimLeavePre", {
      --   callback = function()
	--     -- Always save a special session named "last"
	--     resession.save("last")
	--   end,
	-- })
