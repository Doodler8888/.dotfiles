vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    -- Set text width to 80 characters
    vim.opt_local.textwidth = 80

    -- Enable auto-wrapping
    vim.opt_local.formatoptions:append("t")

    -- Enable auto-wrapping comments using textwidth
    vim.opt_local.formatoptions:append("c")

    -- Remove comment leader when joining lines
    vim.opt_local.formatoptions:append("j")

    -- Don't break lines at single spaces that follow periods
    vim.opt_local.formatoptions:append("q")
  end
})


vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
  pattern = {"*.md", "*.markdown"},
  callback = function()
    local lnum = vim.fn.line(".")
    local col = vim.fn.col(".")
    local concealed = vim.fn.synconcealed(lnum, col) ~= 0
    if concealed and vim.wo.concealcursor ~= "" then
      vim.wo.concealcursor = ""
    elseif not concealed and vim.wo.concealcursor ~= "nc" then
      vim.wo.concealcursor = "nc"
    end
  end,
})


require("markdown").setup({
})

-- -- For some reason, it just doesn't work
vim.keymap.set('i', '<M-CR>', '<cmd>MDListItemBelow<CR>')

-- -- Function to auto-insert a new numbered item
-- local function auto_insert_numbered_item()
--     local current_line = vim.fn.line('.')
--     local current_line_text = vim.fn.getline('.')
--
--     -- Check if the current line already has a number
--     local current_num = current_line_text:match("^%s*(%d+)%.")
--
--     if current_num then
--         -- If current line has a number, increment it
--         local new_num = tonumber(current_num) + 1
--         local new_item = string.format("%d. ", new_num)
--
--         -- Insert the new item on the next line
--         vim.api.nvim_put({new_item}, 'l', true, true)
--
--         -- Move the cursor to the end of the new item
--         vim.api.nvim_win_set_cursor(0, {current_line + 1, #new_item})
--     else
--         -- Search for the previous numbered item
--         local prev_num = nil
--         for i = current_line - 1, 1, -1 do
--             local line = vim.fn.getline(i)
--             local num = line:match("^%s*(%d+)%.")
--             if num then
--                 prev_num = tonumber(num)
--                 break
--             end
--         end
--
--         if prev_num then
--             -- Create the new item
--             local new_num = prev_num + 1
--             local new_item = string.format("%d. ", new_num)
--
--             -- Insert the new item
--             vim.api.nvim_put({new_item}, 'l', true, true)
--
--             -- Move the cursor to the end of the new item
--             vim.api.nvim_win_set_cursor(0, {current_line + 1, #new_item})
--         else
--             -- If no previous number found, just insert a new line
--             vim.api.nvim_put({"", ""}, 'l', true, true)
--         end
--     end
--
--     -- Ensure we're in insert mode at the end
--     vim.cmd('startinsert!')
-- end
--
-- -- Create the user command
-- vim.api.nvim_create_user_command('AutoInsertNumberedItem', auto_insert_numbered_item, {})
--
-- -- Set up the keymapping for Alt+Enter in insert mode
-- -- vim.api.nvim_set_keymap('i', '<M-CR>', '<Esc>:AutoInsertNumberedItem<CR>', {noremap = true, silent = true})
--
--
--
-- -- Function to extract list numbers, sort them starting from 1, and replace them in the buffer
-- local function sort_list_numbers()
--     -- Get the current visual selection
--     local start_line = vim.fn.line("'<")
--     local end_line = vim.fn.line("'>")
--
--     local original_numbers = {}
--     local line_numbers = {}
--
--     -- Iterate through the selected lines
--     for line_num = start_line, end_line do
--         local line = vim.fn.getline(line_num)
--         -- Match numbers at the beginning of the line, possibly with leading spaces
--         local number = line:match("^%s*(%d+)")
--         if number then
--             table.insert(original_numbers, tonumber(number))
--             table.insert(line_numbers, line_num)
--         end
--     end
--
--     -- Create sorted numbers starting from 1
--     local sorted_numbers = {}
--     for i = 1, #original_numbers do
--         sorted_numbers[i] = i
--     end
--
--     -- Replace the numbers in the buffer
--     for i, line_num in ipairs(line_numbers) do
--         local line = vim.fn.getline(line_num)
--         local new_line = line:gsub("^(%s*)%d+", "%1" .. sorted_numbers[i])
--         vim.fn.setline(line_num, new_line)
--     end
--
--     -- Print the original and sorted numbers
--     print("Original numbers: " .. table.concat(original_numbers, ", "))
--     print("Sorted numbers starting from 1: " .. table.concat(sorted_numbers, ", "))
--
--     -- Return focus to the buffer
--     vim.cmd("normal! gv")
-- end
--
-- -- Create a user command
-- vim.api.nvim_create_user_command('SortListNumbers', sort_list_numbers, {range = true})
--
-- -- Create a keymapping (optional)
-- vim.api.nvim_set_keymap('v', '<leader>sn', ':SortListNumbers<CR>', {noremap = true, silent = true})
--
--
-- local function auto_insert_and_sort_numbered_item()mark
--     local current_line = vim.fn.line('.')  -- 1-based
--     local current_line_text = vim.fn.getline('.')
--
--     -- Find the start of the list (search upwards for two consecutive empty lines or start of file)
--     local start_line = current_line
--     while start_line > 2 do
--         local line = vim.fn.getline(start_line - 1)
--         local prev_line = vim.fn.getline(start_line - 2)
--         if line:match("^%s*$") and prev_line:match("^%s*$") then
--             break
--         end
--         start_line = start_line - 1
--     end
--
--     -- Find the end of the list (search downwards for two consecutive empty lines or end of file)
--     local end_line = current_line
--     local last_line = vim.fn.line('$')
--     while end_line < last_line - 1 do
--         local line = vim.fn.getline(end_line + 1)
--         local next_line = vim.fn.getline(end_line + 2)
--         if line:match("^%s*$") and next_line:match("^%s*$") then
--             break
--         end
--         end_line = end_line + 1
--     end
--
--     -- Collect existing numbers
--     local numbers = {}
--     for line_num = start_line, end_line do
--         local line = vim.fn.getline(line_num)
--         local number = line:match("^%s*(%d+)%.")
--         if number then
--             table.insert(numbers, tonumber(number))
--         end
--     end
--
--     -- Determine where to insert the new item
--     local insert_line = current_line
--     local found_numbered_line = false
--     while insert_line >= start_line do
--         local line = vim.fn.getline(insert_line)
--         if line:match("^%s*%d+%.") then
--             found_numbered_line = true
--             break
--         end
--         insert_line = insert_line - 1
--     end
--
--     if found_numbered_line then
--         -- If we found a numbered line, insert after the last line of this item
--         while insert_line < end_line do
--             local next_line = vim.fn.getline(insert_line + 1)
--             if next_line:match("^%s*%d+%.") or next_line:match("^%s*$") then
--                 break
--             end
--             insert_line = insert_line + 1
--         end
--         insert_line = insert_line + 1
--     else
--         -- If we didn't find a numbered line, insert at the current line
--         insert_line = current_line
--     end
--
--     -- Prepare the new item
--     local new_num = #numbers + 1
--     local new_item = string.format("%d. ", new_num)
--
--     -- Insert the new item
--     vim.api.nvim_buf_set_lines(0, insert_line - 1, insert_line - 1, false, { new_item })
--
--     -- Renumber items
--     local current_num = 1
--     for line_num = start_line, end_line + 1 do
--         local line = vim.fn.getline(line_num)
--         local number = line:match("^%s*(%d+)%.")
--         if number then
--             local new_line = line:gsub("^(%s*)%d+%.", "%1" .. current_num .. ".")
--             vim.fn.setline(line_num, new_line)
--             current_num = current_num + 1
--         end
--     end
--
--     -- Move the cursor and enter insert mode
--     vim.api.nvim_win_set_cursor(0, {insert_line, #new_item})
--     vim.cmd('startinsert!')
-- end
--
--
-- -- Create the user command
-- vim.api.nvim_create_user_command('AutoInsertAndSortNumberedItem', auto_insert_and_sort_numbered_item, {})
--
-- -- Keymapping for Alt+Enter in insert mode
-- vim.api.nvim_set_keymap('i', '<M-CR>', '<Esc>:AutoInsertAndSortNumberedItem<CR>', { noremap = true, silent = true })

