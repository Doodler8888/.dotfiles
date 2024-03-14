_G.terminal_buffers = _G.terminal_buffers or {}

local function find_window_by_bufnr(bufnr)
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == bufnr then
            return win
        end
    end
    return nil
end

function _G.open_terminal_in_current_buffer_dir()
    local buf_path = vim.api.nvim_buf_get_name(0)
    local filetype = vim.bo.filetype

    -- Check if the buffer is of type 'oil' and adjust the path
    if filetype == 'oil' then
        buf_path = buf_path:gsub("^oil://", "")
    end

    local buf_dir = vim.fn.fnamemodify(buf_path, ':p:h')

    if buf_dir ~= "" then
        local term_info = _G.terminal_buffers[buf_dir]
        if term_info and vim.api.nvim_buf_is_loaded(term_info.bufnr) then
            local term_win = find_window_by_bufnr(term_info.bufnr)
            if term_win then
                -- Focus the window with the terminal buffer
                vim.api.nvim_set_current_win(term_win)
            else
                -- If the terminal buffer isn't visible in any window, create a new split and display it
                vim.cmd('below split | resize 12')
                vim.api.nvim_set_current_buf(term_info.bufnr)
            end
            -- Attempt to resize only if we have a stored size and the window can be resized
            if term_info.size then
                pcall(vim.api.nvim_win_set_height, 0, term_info.size)
            end
        else
            -- Adjust the terminal command to change the directory properly
            vim.cmd('below split | resize 12 | terminal zsh -c "cd ' .. vim.fn.shellescape(buf_dir) .. ' && exec zsh"')
            local win_height = vim.api.nvim_win_get_height(0)
            local new_term_bufnr = vim.api.nvim_get_current_buf()
            _G.terminal_buffers[buf_dir] = {bufnr = new_term_bufnr, size = win_height}
        end
    else
        print("The current buffer does not have a valid directory.")
    end
end

vim.api.nvim_create_user_command('OpenTermInBufferDir', _G.open_terminal_in_current_buffer_dir, {})
vim.api.nvim_set_keymap('n', '<leader>tt', ':lua _G.open_terminal_in_current_buffer_dir()<CR>', { noremap = true, silent = true })



function CloseAllToggleTermBuffers()
    -- Iterate over all buffers
    local buffers = vim.api.nvim_list_bufs()
    for _, buf in ipairs(buffers) do
        -- Check if the buffer is valid and loaded to avoid errors
        if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
            local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
            -- Check if the buffer is a terminal
            if buftype == "terminal" then
                -- Attempt to close the terminal buffer
                vim.api.nvim_buf_delete(buf, {force = true})
            end
        end
    end
end

vim.api.nvim_set_keymap('n', '<leader>tc', '<cmd>lua CloseAllToggleTermBuffers()<CR>', { noremap = true, silent = true })


-- Create a new command 'W'
vim.api.nvim_create_user_command('W', function()
    CloseAllToggleTermBuffers()
    -- Use vim.cmd to execute a Vim command from Lua
    vim.cmd('wqa')
end, {})

-- vim.api.nvim_set_keymap('n', '<C-n><C-n>', [[:W<CR>]], {noremap = true, silent = true})
