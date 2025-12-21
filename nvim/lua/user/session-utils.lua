local tab_rename = require('user.tab_rename_mksession')
local oil_session = require('user.oil_session')
local session = require('user.session')

vim.opt.sessionoptions = 'curdir,folds,globals,help,tabpages,terminal,winsize'

_G.current_session_name = nil

-- Autocmds
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    if _G.session_loaded and _G.current_session_name then
      _G.save_session(_G.current_session_name)
    end
  end,
})

vim.api.nvim_create_autocmd("SessionLoadPost", {
    callback = function()
        local session_path = vim.v.this_session
        if session_path and session_path ~= "" then
            tab_rename.load_tab_names(session_path)
            oil_session.load_oil_buffers(session_path)
            vim.cmd('redrawtabline')
        end
    end,
})

vim.keymap.set("n", "<leader>ss", function() require("user.session").save() end, { desc = "Save Session" })
