local M = {}

-- Initialize custom_tab_names only if it doesn't exist
_G.custom_tab_names = _G.custom_tab_names or {}

function M.set_tabname()
    local tabnr = vim.api.nvim_tabpage_get_number(vim.api.nvim_get_current_tabpage())
    vim.ui.input({ prompt = 'Tab name: ' }, function(name)
        if name then
            _G.custom_tab_names[tabnr] = name
            vim.cmd('redrawtabline')
        end
    end)
end

function M.get_tabname(tab)
    local tabnr = type(tab) == "number" and tab or vim.api.nvim_tabpage_get_number(tab)
    return _G.custom_tab_names[tabnr]
end

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

        tabline = tabline .. ' '..vim.api.nvim_tabpage_get_number(tab)..' '

        local custom_name = M.get_tabname(tab)
        if custom_name then
            tabline = tabline .. tostring(custom_name)
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

_G.custom_tabline = M.custom_tabline
vim.o.tabline = '%!v:lua.custom_tabline()'

vim.keymap.set('n', '<leader>tr', M.set_tabname, { desc = "Rename tab" })

-- Function to get the path for the tab names file
local function get_tab_names_path(session_path)
    return session_path .. '.tabnames'
end

-- Save tab names to a file
function M.save_tab_names(session_path)
    local tab_names_path = get_tab_names_path(session_path)
    local file = io.open(tab_names_path, "w")
    if not file then
        print("Error: Could not open file for writing: " .. tab_names_path)
        return
    end
    file:write(vim.fn.json_encode(_G.custom_tab_names))
    file:close()
end

-- Load tab names from a file
function M.load_tab_names(session_path)
    local tab_names_path = get_tab_names_path(session_path)
    local file = io.open(tab_names_path, "r")
    if not file then
        return -- File may not exist, which is fine
    end
    local content = file:read("*a")
    file:close()
    if content and content ~= "" then
        local data = vim.fn.json_decode(content)
        local tabs = vim.api.nvim_list_tabpages()
        for _, tab in ipairs(tabs) do
            local tabnr = vim.api.nvim_tabpage_get_number(tab)
            if data[tabnr] and data[tabnr] ~= vim.NIL then
                _G.custom_tab_names[tabnr] = data[tabnr]
            end
        end
        vim.cmd('redrawtabline')
    end
end


return M
