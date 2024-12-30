-- in lua/user/blink.lua
local blink = require('blink-cmp')

-- More robust keymap with fallback
vim.keymap.set('i', '<Tab>', function()
    if blink.is_visible() then
        blink.accept()
        return
    end

    blink.show()
    if not blink.is_visible() then
        -- Fallback to regular Tab if completion isn't shown
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, true, true), 'n', false)
    end
end, { expr = false, silent = true })

-- Optional: Add Shift-Tab for reverse navigation
vim.keymap.set('i', '<S-Tab>', function()
    if blink.is_visible() then
        blink.select_prev()
    else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<S-Tab>', true, true, true), 'n', false)
    end
end, { expr = false, silent = true })

blink.setup({
    completion = {
        menu = {
            auto_show = false
        },
        ghost_text = {
            enabled = true
        }
    }
})
