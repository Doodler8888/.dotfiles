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
-- vim.api.nvim_set_keymap('i', '<M-CR>', '<Esc>:AutoInsertNumberedItem<CR>', {noremap = true, silent = true})



-- Function to extract list numbers, sort them starting from 1, and replace them in the buffer
local function sort_list_numbers()
    -- Get the current visual selection
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")

    local original_numbers = {}
    local line_numbers = {}

    -- Iterate through the selected lines
    for line_num = start_line, end_line do
        local line = vim.fn.getline(line_num)
        -- Match numbers at the beginning of the line, possibly with leading spaces
        local number = line:match("^%s*(%d+)")
        if number then
            table.insert(original_numbers, tonumber(number))
            table.insert(line_numbers, line_num)
        end
    end

    -- Create sorted numbers starting from 1
    local sorted_numbers = {}
    for i = 1, #original_numbers do
        sorted_numbers[i] = i
    end

    -- Replace the numbers in the buffer
    for i, line_num in ipairs(line_numbers) do
        local line = vim.fn.getline(line_num)
        local new_line = line:gsub("^(%s*)%d+", "%1" .. sorted_numbers[i])
        vim.fn.setline(line_num, new_line)
    end

    -- Print the original and sorted numbers
    print("Original numbers: " .. table.concat(original_numbers, ", "))
    print("Sorted numbers starting from 1: " .. table.concat(sorted_numbers, ", "))

    -- Return focus to the buffer
    vim.cmd("normal! gv")
end

-- Create a user command
vim.api.nvim_create_user_command('SortListNumbers', sort_list_numbers, {range = true})

-- Create a keymapping (optional)
vim.api.nvim_set_keymap('v', '<leader>sn', ':SortListNumbers<CR>', {noremap = true, silent = true})


local function auto_insert_and_sort_numbered_item()
    local current_line = vim.fn.line('.')
    local current_line_text = vim.fn.getline('.')

    -- Find the start of the list (search upwards for two consecutive empty lines or start of file)
    local start_line = current_line
    while start_line > 2 do
        local line = vim.fn.getline(start_line - 1)
        local prev_line = vim.fn.getline(start_line - 2)
        if line:match("^%s*$") and prev_line:match("^%s*$") then
            break
        end
        start_line = start_line - 1
    end

    -- Find the end of the list (search downwards for two consecutive empty lines or end of file)
    local end_line = current_line
    local last_line = vim.fn.line('$')
    while end_line < last_line - 1 do
        local line = vim.fn.getline(end_line + 1)
        local next_line = vim.fn.getline(end_line + 2)
        if line:match("^%s*$") and next_line:match("^%s*$") then
            break
        end
        end_line = end_line + 1
    end

    local numbers = {}
    local line_numbers = {}

    -- Collect existing numbers
    for line_num = start_line, end_line do
        local line = vim.fn.getline(line_num)
        local number = line:match("^%s*(%d+)")
        if number then
            table.insert(numbers, tonumber(number))
            table.insert(line_numbers, line_num)
        end
    end

    local new_item_inserted = false
    local new_item_length = 0

    -- Insert a new item if we're not on a numbered line
    if not current_line_text:match("^%s*%d+") then
        local new_num = #numbers + 1
        local new_item = string.format("%d. ", new_num)
        vim.api.nvim_put({new_item}, 'l', true, true)
        table.insert(numbers, new_num)
        table.insert(line_numbers, current_line)
        end_line = end_line + 1
        new_item_inserted = true
        new_item_length = #new_item
    end

    -- Create sorted numbers starting from 1
    local sorted_numbers = {}
    for i = 1, #numbers do
        sorted_numbers[i] = i
    end

    -- Replace the numbers in the buffer
    for i, line_num in ipairs(line_numbers) do
        local line = vim.fn.getline(line_num)
        local new_line = line:gsub("^(%s*)%d+", "%1" .. sorted_numbers[i])
        vim.fn.setline(line_num, new_line)
    end

    -- Move the cursor to the end of the new item if one was inserted
    if new_item_inserted then
        vim.api.nvim_win_set_cursor(0, {current_line + 1, new_item_length})
        vim.cmd('startinsert!')
    end
end

-- Create the user command
vim.api.nvim_create_user_command('AutoInsertAndSortNumberedItem', auto_insert_and_sort_numbered_item, {})

-- Set up the keymapping for Alt+Enter in insert mode
vim.api.nvim_set_keymap('i', '<M-CR>', '<Esc>:AutoInsertAndSortNumberedItem<CR>', {noremap = true, silent = true})
