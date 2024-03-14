require("resession").setup({
  autosave = {
    enabled = true,
    interval = 30,
    notify = false,
  },
-- Save and restore these options
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
})


local resession = require("resession")
resession.setup()
-- Resession does NOTHING automagically, so we have to set up some keymaps
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

-- vim.api.nvim_create_autocmd("VimLeavePre", {
--   callback = function()
--     require('resession').save()
--   end,
-- })

-- vim.api.nvim_create_autocmd("VimLeavePre", {
--   callback = function()
--     -- Always save a special session named "last"
--     resession.save("last")
--   end,
-- })
