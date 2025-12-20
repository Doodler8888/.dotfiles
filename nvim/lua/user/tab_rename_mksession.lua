local M = {}

-- Initialize custom_tab_names only if it doesn't exist
_G.custom_tab_names = _G.custom_tab_names or {}

function M.set_tabname()
    local tabnr = vim.api.nvim_tabpage_get_number(vim.api.nvim_get_current_tabpage())
    vim.ui.input({ prompt = 'Tab name: ' }, function(name)
        if name then
            -- FIX: Convert tabnr to string to ensure consistent key usage
            _G.custom_tab_names[tostring(tabnr)] = name
            vim.cmd('redrawtabline')
        end
    end)
end

function M.get_tabname(tab)
    local tabnr = type(tab) == "number" and tab or vim.api.nvim_tabpage_get_number(tab)
    -- FIX: Retrieve using string key
    return _G.custom_tab_names[tostring(tabnr)]
end

function M.custom_tabline()
    local tabline = ''
    local current_tab = vim.api.nvim_get_current_tabpage()
    local tabs = vim.api.nvim_list_tabpages()

    for _, tab in ipairs(tabs) do
        -- Highlight selection
        if tab == current_tab then
            tabline = tabline .. '%#TabLineSel#'
        else
            tabline = tabline .. '%#TabLine#'
        end

        local tabnr = vim.api.nvim_tabpage_get_number(tab)

        -- Add Tab number
        tabline = tabline .. ' ' .. tabnr .. ' '

        local custom_name = M.get_tabname(tab)

        if custom_name and custom_name ~= "" then
            tabline = tabline .. custom_name
        else
            -- Fallback to buffer name
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

local function get_tab_names_path(session_path)
    return session_path .. '.tabnames'
end

function M.save_tab_names(session_path)
    local tab_names_path = get_tab_names_path(session_path)
    local file = io.open(tab_names_path, "w")
    if not file then
        print("Error: Could not open file for writing: " .. tab_names_path)
        return
    end
    -- This now saves {"1": "Name", "2": "Name"} which is unambiguous in JSON
    file:write(vim.fn.json_encode(_G.custom_tab_names))
    file:close()
end

function M.load_tab_names(session_path)
    local tab_names_path = get_tab_names_path(session_path)
    local file = io.open(tab_names_path, "r")
    if not file then return end

    local content = file:read("*a")
    file:close()

    if content and content ~= "" then
        local status, data = pcall(vim.fn.json_decode, content)
        if not status or not data then return end

        -- Clear current names to prevent ghosting
        _G.custom_tab_names = {}

        -- FIX: Iterate pairs and force keys to strings
        -- JSON decode might return keys as strings ("1") or numbers (1) depending on format
        for k, v in pairs(data) do
            if v and v ~= vim.NIL then
                _G.custom_tab_names[tostring(k)] = v
            end
        end
        vim.cmd('redrawtabline')
    end
end

return M
