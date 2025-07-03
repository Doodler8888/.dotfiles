-- lua/user/oil_session.lua

local M = {}

-- Gets the path for the file that will store the oil buffer paths.
local function get_oil_buffers_path(session_path)
    return session_path .. '.oil'
end

-- Saves the paths of all open oil.nvim buffers.
function M.save_oil_buffers(session_path)
    local oil_paths = {}
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].filetype == 'oil' then
            local buf_name = vim.api.nvim_buf_get_name(bufnr)
            local path = buf_name:gsub('oil://', '')
            if path and path ~= '' then
                table.insert(oil_paths, path)
            end
        end
    end

    if #oil_paths > 0 then
        local oil_buffers_path = get_oil_buffers_path(session_path)
        local file = io.open(oil_buffers_path, "w")
        if not file then
            vim.notify("Error: Could not open oil session file for writing.", vim.log.levels.ERROR)
            return
        end
        file:write(vim.fn.json_encode(oil_paths))
        file:close()
    end
end

-- Loads the oil.nvim buffers from the saved file.
function M.load_oil_buffers(session_path)
    local oil_buffers_path = get_oil_buffers_path(session_path)
    if vim.fn.filereadable(oil_buffers_path) ~= 1 then
        return
    end

    local file = io.open(oil_buffers_path, "r")
    if not file then
        return
    end

    local content = file:read("*a")
    file:close()

    if not content or content == "" then
        return
    end

    local oil_paths = vim.fn.json_decode(content)
    if not oil_paths or type(oil_paths) ~= 'table' or #oil_paths == 0 then
        return
    end

    vim.schedule(function()
        -- Find all "empty" windows that were likely placeholders for oil buffers.
        local empty_windows = {}
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            local bufnr = vim.api.nvim_win_get_buf(win)
            if vim.api.nvim_buf_is_loaded(bufnr) then
                local buf_name = vim.api.nvim_buf_get_name(bufnr)
                -- An "empty" buffer has no name and is not modified.
                if buf_name == '' and not vim.bo[bufnr].modified then
                    table.insert(empty_windows, win)
                end
            end
        end

        if #empty_windows == 0 then
            return
        end

        -- Restore oil buffers into the empty windows.
        local current_win = vim.api.nvim_get_current_win()
        for i, win_id in ipairs(empty_windows) do
            if i <= #oil_paths then
                local path = oil_paths[i]
                if vim.api.nvim_win_is_valid(win_id) then
                    vim.api.nvim_set_current_win(win_id)
                    vim.cmd("Oil " .. path)
                end
            end
        end
        vim.api.nvim_set_current_win(current_win)
    end)
end

return M
