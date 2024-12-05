-- local M = {}
--
-- -- Store tab names in a global table
-- _G.custom_tab_names = {}
--
-- -- Function to set a custom name for the current tab
-- function M.set_tabname()
--     local tabnr = vim.api.nvim_get_current_tabpage()
--     vim.ui.input({ prompt = 'Tab name: ' }, function(name)
--         if name then
--             _G.custom_tab_names[tabnr] = name
--             vim.cmd('redrawtabline')
--         end
--     end)
-- end
--
-- -- Function to get custom tab name
-- function M.get_tabname(tabnr)
--     return _G.custom_tab_names[tabnr]
-- end
--
-- -- Function to generate the tabline
-- function M.custom_tabline()
--     local tabline = ''
--     local current_tab = vim.api.nvim_get_current_tabpage()
--     local tabs = vim.api.nvim_list_tabpages()
--
--     for _, tab in ipairs(tabs) do
--         if tab == current_tab then
--             tabline = tabline .. '%#TabLineSel#'
--         else
--             tabline = tabline .. '%#TabLine#'
--         end
--
--         tabline = tabline .. ' ['..vim.api.nvim_tabpage_get_number(tab)..'] '
--
--         local custom_name = M.get_tabname(tab)
--         if custom_name then
--             tabline = tabline .. custom_name
--         else
--             local wins = vim.api.nvim_tabpage_list_wins(tab)
--             if #wins > 0 then
--                 local buf = vim.api.nvim_win_get_buf(wins[1])
--                 local buf_name = vim.api.nvim_buf_get_name(buf)
--                 tabline = tabline .. (buf_name ~= '' and vim.fn.fnamemodify(buf_name, ':t') or '[No Name]')
--             end
--         end
--
--         tabline = tabline .. ' '
--     end
--
--     tabline = tabline .. '%#TabLineFill#'
--     return tabline
-- end
--
-- -- Make the custom_tabline function globally available
-- _G.custom_tabline = M.custom_tabline
--
-- return M


local M = {}

-- Store tab names in a global table
_G.custom_tab_names = {}

-- Function to set a custom name for the current tab
function M.set_tabname()
    local tabpage = vim.api.nvim_get_current_tabpage()
    vim.ui.input({ prompt = 'Tab name: ' }, function(name)
        if name then
            _G.custom_tab_names[tabpage] = name
            vim.cmd('redrawtabline')
        end
    end)
end

-- Function to get custom tab name
function M.get_tabname(tabpage)
    return _G.custom_tab_names[tabpage]
end

-- Function to generate the tabline
function M.custom_tabline()
    local tabline = ''
    local current_tab = vim.api.nvim_get_current_tabpage()
    local tabs = vim.api.nvim_list_tabpages()

    for _, tab in ipairs(tabs) do
        if tab == current_tab then
            tabline = tabline .. '%#TabLineSel#'
        else
            tabline = tabline .. '%#TabLine#'
        end

        tabline = tabline .. ' ['..vim.api.nvim_tabpage_get_number(tab)..'] '

        local custom_name = M.get_tabname(tab)
        if custom_name then
            tabline = tabline .. custom_name
        else
            local wins = vim.api.nvim_tabpage_list_wins(tab)
            if #wins > 0 then
                local buf = vim.api.nvim_win_get_buf(wins[1])
                local buf_name = vim.api.nvim_buf_get_name(buf)
                tabline = tabline .. (buf_name ~= '' and vim.fn.fnamemodify(buf_name, ':t') or '[No Name]')
            end
        end

        tabline = tabline .. ' '
    end

    tabline = tabline .. '%#TabLineFill#'
    return tabline
end

-- Make the custom_tabline function globally available
_G.custom_tabline = M.custom_tabline

return M


-- I also probably need to add this into a non-module file like init, into a
-- non-module file like set.lua:

-- local tabline = require('lua.custom.tab_rename')
--
-- -- Set up the tabline
-- vim.opt.tabline = '%!v:lua.custom_tabline()'
--
-- -- Set up the keybinding
-- vim.keymap.set('n', '<leader>tr', tabline.set_tabname, { desc = 'Rename current tab' })
