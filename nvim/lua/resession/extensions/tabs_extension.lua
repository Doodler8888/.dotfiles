local M = {}

M.on_save = function(opts)
    local saved_names = {}
    local tabs = vim.api.nvim_list_tabpages()
    for _, tab in ipairs(tabs) do
        local tabnr = vim.api.nvim_tabpage_get_number(tab)
        if _G.custom_tab_names[tabnr] then
            saved_names[tabnr] = _G.custom_tab_names[tabnr]
        end
    end
    return saved_names
end

M.on_post_load = function(data)
    local tabs = vim.api.nvim_list_tabpages()
    for _, tab in ipairs(tabs) do
        local tabnr = vim.api.nvim_tabpage_get_number(tab)
        if data[tabnr] then
            _G.custom_tab_names[tabnr] = data[tabnr]
        end
    end
    vim.cmd('redrawtabline')
end

return M
