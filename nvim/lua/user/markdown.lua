local function continue_list()
    -- Get current line and line above
    local current_line = vim.fn.line('.')
    local above_text = vim.api.nvim_buf_get_lines(0, current_line - 2, current_line - 1, false)[1]

    -- Check if we're in a numbered list by looking at the line above
    local number = above_text and above_text:match("^(%d+)%.")

    if number then
        -- Convert to number and increment
        number = tonumber(number) + 1

        -- Insert new numbered item
        local new_line = string.format("%d. ", number)
        vim.api.nvim_set_current_line(new_line)

        -- Move cursor to end of line
        vim.api.nvim_win_set_cursor(0, {current_line, #new_line})

        -- Enter insert mode
        vim.cmd('startinsert!')

        -- Reorder the list if needed
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local start_line = current_line
        while start_line > 1 and lines[start_line-1]:match("^%d+%.") do
            start_line = start_line - 1
        end

        -- Reorder numbers
        local count = 1
        for i = start_line, #lines do
            if lines[i]:match("^%d+%.") then
                lines[i] = lines[i]:gsub("^%d+%.", count .. ".")
                count = count + 1
            end
        end

        vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    end
end


-- M-RET is <M-CR> or <A-CR> in Neovim
vim.keymap.set('n', '<M-CR>', function()
    if vim.bo.filetype == 'markdown' then
        continue_list()
    end
end, { desc = "Continue list in markdown" })

-- Also add insert mode mapping
vim.keymap.set('i', '<M-CR>', function()
    if vim.bo.filetype == 'markdown' then
        vim.cmd('stopinsert')  -- exit insert mode temporarily
        continue_list()
    end
end, { desc = "Continue list in markdown" })
