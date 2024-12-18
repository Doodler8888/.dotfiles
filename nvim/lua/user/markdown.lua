-- Function to auto-insert a new numbered item
local function auto_insert_numbered_item()
    local current_line = vim.fn.line('.')
    local current_line_text = vim.fn.getline('.')

    -- Check if the current line already has a number
    local current_num = current_line_text:match("^%s*(%d+)%.")

    if current_num then
        -- If current line has a number, increment it
        local new_num = tonumber(current_num) + 1
        local new_item = string.format("%d. ", new_num)

        -- Insert the new item on the next line
        vim.api.nvim_put({new_item}, 'l', true, true)

        -- Move the cursor to the end of the new item
        vim.api.nvim_win_set_cursor(0, {current_line + 1, #new_item})
    else
        -- Search for the previous numbered item
        local prev_num = nil
        for i = current_line - 1, 1, -1 do
            local line = vim.fn.getline(i)
            local num = line:match("^%s*(%d+)%.")
            if num then
                prev_num = tonumber(num)
                break
            end
        end

        if prev_num then
            -- Create the new item
            local new_num = prev_num + 1
            local new_item = string.format("%d. ", new_num)

            -- Insert the new item
            vim.api.nvim_put({new_item}, 'l', true, true)

            -- Move the cursor to the end of the new item
            vim.api.nvim_win_set_cursor(0, {current_line + 1, #new_item})
        else
            -- If no previous number found, just insert a new line
            vim.api.nvim_put({"", ""}, 'l', true, true)
        end
    end

    -- Ensure we're in insert mode at the end
    vim.cmd('startinsert!')
end

-- Create the user command
vim.api.nvim_create_user_command('AutoInsertNumberedItem', auto_insert_numbered_item, {})

-- Set up the keymapping for Alt+Enter in insert mode
vim.api.nvim_set_keymap('i', '<M-CR>', '<Esc>:AutoInsertNumberedItem<CR>', {noremap = true, silent = true})

