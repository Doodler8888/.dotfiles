function Copy_full_path()
    local full_path = vim.fn.expand('%:p')
    -- Check if the current buffer's filetype is 'oil'
    if vim.bo.filetype == 'oil' then
        -- Trim the 'oil://' prefix from the full path
        full_path = full_path:gsub("^oil://", "")
    end
    vim.fn.setreg('+', full_path)
    print('Copied path: ' .. full_path)
end

-- New function to copy only the file name
function Copy_file_name()
    local file_name = vim.fn.expand('%:t')
    vim.fn.setreg('+', file_name)
    print('Copied file name: ' .. file_name)
end

-- Create commands
vim.api.nvim_create_user_command('Cp', Copy_full_path, {})
vim.api.nvim_create_user_command('Cpf', Copy_file_name, {})


function TrimWhitespace()
    -- Get the current line number and column
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local line_num = cursor_pos[1]
    local col_num = cursor_pos[2]

    -- Get the current line content
    local line = vim.api.nvim_buf_get_lines(0, line_num-1, line_num, false)[1]

    -- Split the line at the cursor's position
    local first_part = line:sub(1, col_num)
    local second_part = line:sub(col_num + 1)

    -- Trim the whitespace from the end of the first part
    first_part = first_part:gsub("%s*$", "")

    -- Join the parts back together
    local trimmed_line = first_part .. second_part

    -- Set the trimmed line back
    vim.api.nvim_buf_set_lines(0, line_num-1, line_num, false, {trimmed_line})

    -- Move the cursor to the end of the trimmed first part
    vim.api.nvim_win_set_cursor(0, {line_num, #first_part})
end

vim.api.nvim_set_keymap('i', '<C-d>', '<cmd>lua TrimWhitespace()<CR>', { noremap = true, silent = true })


local function change_to_buffer_dir()
  -- Check if the current buffer is a netrw buffer
  local is_netrw = vim.fn.exists("g:netrw_dir") == 1
  local buftdir

  if is_netrw then
    -- In netrw, the current directory is stored in a global variable
    buftdir = vim.g.netrw_dir
  else
    -- Get the current buffer's full path
    local bufname = vim.api.nvim_buf_get_name(0)
    -- Check if the buffer is of type 'oil'
    local filetype = vim.bo.filetype

    if filetype == 'oil' then
      -- Assuming the 'oil' filetype paths always start with 'oil://'
      -- Trim the 'oil://' part and adjust the path as needed
      bufname = bufname:gsub("^oil://", "")
    end

    -- Extract the directory from the buffer's (possibly adjusted) full path
    buftdir = vim.fn.fnamemodify(bufname, ':p:h')
  end

  -- Change Neovim's current working directory to the buffer's directory
  vim.cmd('tcd ' .. buftdir)
end

-- Create a Neovim command called "CdToBufferDir" that invokes the function
vim.api.nvim_create_user_command('Cd', change_to_buffer_dir, {})


function ShowMessagesInNewBuffer()
  local bufname = "Neovim Messages"
  local existing_bufnr = vim.fn.bufnr(bufname)

  if existing_bufnr ~= -1 then
    -- Buffer exists: switch to it
    vim.api.nvim_set_current_buf(existing_bufnr)
    return
  end

  -- Capture the output of the :messages command
  local messages_output = vim.api.nvim_exec('messages', true)
  local lines = {}
  for s in messages_output:gmatch("[^\r\n]+") do
    table.insert(lines, s)
  end

  -- Create a new buffer and open it in a new window
  vim.api.nvim_command('enew')
  local bufnr = vim.api.nvim_get_current_buf()

  -- Set buffer options (modified section)
  vim.api.nvim_buf_set_option(bufnr, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(bufnr, 'bufhidden', 'hide')
  vim.api.nvim_buf_set_option(bufnr, 'swapfile', false)
  vim.api.nvim_buf_set_option(bufnr, 'filetype', 'nvim-messages')
  vim.api.nvim_buf_set_option(bufnr, 'buflisted', false)  -- Keep unlisted but trackable

  -- Make the buffer writable before inserting the messages
  vim.api.nvim_buf_set_option(bufnr, 'modifiable', true)

  -- Insert the captured messages into the buffer
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

  -- Scroll to the start of the buffer
  vim.api.nvim_command('normal! gg')

  -- Set the buffer to read-only to prevent editing
  vim.api.nvim_buf_set_option(bufnr, 'modifiable', false)

  -- Create a buffer-local keybinding for 'q' to close the buffer
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'q', ':bdelete<CR>', { noremap = true, silent = true })

  -- Finally, set the buffer name so that future calls can find it
  vim.api.nvim_buf_set_name(bufnr, bufname)
end



-- You can bind the function to a command in Neovim
vim.api.nvim_create_user_command('ShowMessages', ShowMessagesInNewBuffer, {})
vim.api.nvim_set_keymap('n', '<Leader>mm', ':ShowMessages<CR>', {noremap = true, silent = true})


-- Function to temporarily disable auto-indentation, insert new lines below, and then re-enable auto-indentation
function _G.insert_new_line_below(count)
  count = count or 1
  local auto_indent = vim.api.nvim_buf_get_option(0, 'autoindent')
  vim.api.nvim_buf_set_option(0, 'autoindent', false)
  for _ = 1, count do
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('o<Esc>', true, true, true), 'n', true)
  end
  vim.api.nvim_buf_set_option(0, 'autoindent', auto_indent)
  vim.api.nvim_feedkeys('i', 'n', true)
end

-- Function to temporarily disable auto-indentation, insert new lines above, and then re-enable auto-indentation
function _G.insert_new_line_above(count)
  count = count or 1
  local auto_indent = vim.api.nvim_buf_get_option(0, 'autoindent')
  vim.api.nvim_buf_set_option(0, 'autoindent', false)
  for _ = 1, count do
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('O<Esc>', true, true, true), 'n', true)
  end
  vim.api.nvim_buf_set_option(0, 'autoindent', auto_indent)
  vim.api.nvim_feedkeys('i', 'n', true)
end

-- Map go to insert new lines below without auto-indentation
vim.api.nvim_set_keymap('n', 'go', ':<C-u>lua insert_new_line_below(vim.v.count1)<CR>', {noremap = true, silent = true})

-- Map gO to insert new lines above without auto-indentation
vim.api.nvim_set_keymap('n', 'gO', ':<C-u>lua insert_new_line_above(vim.v.count1)<CR>', {noremap = true, silent = true})


vim.g.zoxide_custom_action = {
  Z = {
    cmd = 'Oil',
    is_dir_only = true
  }
}


function GitInitCustomBranch()
  -- Get the current path, handling oil buffers specially
  local cwd
  if vim.bo.filetype == "oil" then
    -- Remove the "oil:///" prefix from the path for oil buffers
    cwd = vim.fn.expand('%:p'):gsub("^oil:///", "/")
  else
    -- For regular buffers, get the absolute path of the current buffer's directory
    local buffer_dir = vim.fn.expand('%:p:h')
    cwd = (buffer_dir ~= '') and buffer_dir or vim.fn.getcwd()
  end

  -- Prompt for confirmation or editing of the path
  local confirmed_path = vim.fn.input("Initialize Git repository at: ", cwd)
  -- Clear the command line
  vim.cmd("redraw")
  if confirmed_path == nil or confirmed_path == "" then
    print("Path cannot be empty. Git init aborted.")
    return
  end
  -- Prompt for branch name
  local branch_name = vim.fn.input("Enter the name for the initial branch: ")
  -- Clear the command line
  vim.cmd("redraw")
  if branch_name == nil or branch_name == "" then
    print("Branch name cannot be empty. Git init aborted.")
    return
  end
  -- Construct the command
  local cmd = string.format("cd %s && git init -b %s", vim.fn.shellescape(confirmed_path), vim.fn.shellescape(branch_name))
  -- Execute git init with the custom branch
  local output = vim.fn.system(cmd)
  -- Check if the command was successful
  if vim.v.shell_error == 0 then
    print(string.format("Git repository initialized at %s with initial branch: %s", confirmed_path, branch_name))
  else
    print("Failed to initialize Git repository.")
    print("Error: " .. output)
  end
end

-- Create a user command to call the function
vim.api.nvim_create_user_command("GitInitCustomBranch", GitInitCustomBranch, {})
vim.api.nvim_set_keymap('n', '<leader>gi', ':GitInitCustomBranch<CR>', { noremap = true, silent = true })


local function reload_file()
  -- Save cursor position and window state
  local view = vim.fn.winsaveview()
  vim.cmd('edit')  -- Reload buffer
  vim.fn.winrestview(view)  -- Restore cursor/window state
  vim.notify('File reloaded from disk', vim.log.levels.INFO)
end

-- Then create the mapping DIRECTLY to the function
vim.api.nvim_set_keymap('n', '<Leader>rr', '', {
  noremap = true,
  silent = true,
  callback = reload_file  -- Directly use the local function
})


-- -- This is the code for mimicking emacs functionality for switching between
-- -- buffers in history
-- -- MRU buffer history implementation
-- -- MRU buffer history implementation
-- local buf_history = {}
-- local history_index = 0
-- local in_navigation = false
--
-- -- Prune invalid buffers from history
-- local function prune_history()
--     local new_history = {}
--     for _, buf in ipairs(buf_history) do
--         if vim.api.nvim_buf_is_valid(buf) then
--             table.insert(new_history, buf)
--         end
--     end
--     buf_history = new_history
--     history_index = math.min(math.max(history_index, 1), #buf_history)
-- end
--
-- -- Update history on buffer enter
-- local function on_buf_enter()
--     if in_navigation then
--         in_navigation = false
--         return
--     end
--
--     local current_buf = vim.api.nvim_get_current_buf()
--     prune_history()
--
--     -- Remove current buffer from history if it exists
--     for i = #buf_history, 1, -1 do
--         if buf_history[i] == current_buf then
--             table.remove(buf_history, i)
--             if history_index >= i then
--                 history_index = history_index - 1
--             end
--         end
--     end
--
--     -- Add current buffer to end of history
--     table.insert(buf_history, current_buf)
--     history_index = #buf_history
--
--     vim.notify("History updated: " .. vim.inspect(buf_history), vim.log.levels.DEBUG)
-- end
--
-- vim.api.nvim_create_autocmd("BufEnter", {
--     pattern = "*",
--     callback = on_buf_enter,
-- })
--
-- -- Navigate through history
-- local function navigate_buffer(offset)
--     prune_history()
--
--     if #buf_history == 0 then
--         vim.notify("No buffer history", vim.log.levels.WARN)
--         return
--     end
--
--     local new_index = history_index + offset
--     new_index = math.max(1, math.min(new_index, #buf_history))
--
--     if new_index == history_index then
--         vim.notify("Reached end of history", vim.log.levels.DEBUG)
--         return
--     end
--
--     history_index = new_index
--     local target_buf = buf_history[history_index]
--
--     if vim.api.nvim_buf_is_valid(target_buf) then
--         in_navigation = true
--         vim.api.nvim_set_current_buf(target_buf)
--     else
--         vim.notify("Invalid buffer in history: " .. target_buf, vim.log.levels.WARN)
--     end
-- end
--
-- vim.keymap.set("n", "<C-Tab>", function() navigate_buffer(-1) end, { noremap = true, silent = true })
-- vim.keymap.set("n", "<S-Tab>", function() navigate_buffer(1) end, { noremap = true, silent = true })



-- local buf_history = {}
-- local current_index = 0
-- local is_navigating = false
-- local last_history_state = ""
--
-- -- Generate a compact string representation of the current history state
-- local function get_history_state()
--     local parts = {}
--     for i, buf in ipairs(buf_history) do
--         local name = vim.api.nvim_buf_get_name(buf)
--         local filetype = vim.api.nvim_buf_get_option(buf, 'filetype')
--
--         -- Create short, meaningful names
--         local short_name
--         if filetype == 'oil' then
--             local dir = name:match("^oil://(.*)") or name
--             short_name = "oil:" .. dir:match("([^/]+)/?$") or "[root]"
--         else
--             short_name = name:match("([^/]+)$") or "[No name]"
--         end
--
--         -- Mark current position
--         if i == current_index then
--             short_name = "*" .. short_name .. "*"
--         end
--
--         table.insert(parts, short_name)
--     end
--
--     return "[" .. table.concat(parts, ", ") .. "]"
-- end
--
-- -- Debug function that only shows changes
-- local function debug_history()
--     local current_state = get_history_state()
--
--     if current_state ~= last_history_state then
--         vim.notify("Buffer history: " .. current_state, vim.log.levels.DEBUG)
--         last_history_state = current_state
--     end
-- end
--
-- -- Check if a buffer should be tracked
-- local function is_trackable_buffer(bufnr)
--     if not vim.api.nvim_buf_is_valid(bufnr) then
--         return false
--     end
--
--     local buftype = vim.api.nvim_buf_get_option(bufnr, 'buftype')
--     local bufname = vim.api.nvim_buf_get_name(bufnr)
--     local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
--
--     -- Special handling for oil.nvim buffers
--     if filetype == 'oil' then
--         return true
--     end
--
--     -- Skip special buffer types except regular files and directories
--     if buftype ~= '' and buftype ~= 'acwrite' and buftype ~= 'nofile' then
--         return false
--     end
--
--     -- For empty names, only track if it's a modifiable buffer
--     if bufname == '' then
--         return vim.api.nvim_buf_get_option(bufnr, 'modifiable')
--     end
--
--     -- Check if it's a real file or directory
--     return vim.fn.filereadable(bufname) == 1 or vim.fn.isdirectory(bufname) == 1
-- end
--
-- -- The rest of the code remains the same...
--
-- -- Remove adjacent duplicates from history
-- local function deduplicate_adjacent()
--     if #buf_history <= 1 then return end
--
--     local i = 1
--     while i < #buf_history do
--         if buf_history[i] == buf_history[i+1] then
--             table.remove(buf_history, i+1)
--             if current_index > i then
--                 current_index = current_index - 1
--             end
--         else
--             i = i + 1
--         end
--     end
-- end
--
-- -- Prune invalid buffers from history
-- local function prune_history()
--     local new_history = {}
--     for i, buf in ipairs(buf_history) do
--         if vim.api.nvim_buf_is_valid(buf) and is_trackable_buffer(buf) then
--             table.insert(new_history, buf)
--         else
--             vim.notify("Removing invalid buffer from history", vim.log.levels.DEBUG)
--             if i <= current_index then
--                 current_index = current_index - 1
--             end
--         end
--     end
--     buf_history = new_history
--     current_index = math.max(0, math.min(current_index, #buf_history))
--     deduplicate_adjacent()
--     debug_history()
-- end
--
-- -- Update history on buffer enter
-- local function on_buf_enter()
--     if is_navigating then
--         is_navigating = false
--         debug_history()
--         return
--     end
--
--     local current_buf = vim.api.nvim_get_current_buf()
--
--     -- Check if the current buffer should be tracked
--     if not is_trackable_buffer(current_buf) then
--         vim.notify("Buffer not trackable, skipping history update", vim.log.levels.DEBUG)
--         return
--     end
--
--     prune_history()
--
--     -- If we're not at the end of history, truncate forward history
--     if current_index < #buf_history then
--         buf_history = {unpack(buf_history, 1, current_index)}
--         vim.notify("Truncated forward history", vim.log.levels.DEBUG)
--     end
--
--     -- Add current buffer to history
--     table.insert(buf_history, current_buf)
--     current_index = #buf_history
--
--     -- Remove adjacent duplicates
--     deduplicate_adjacent()
--     debug_history()
-- end
--
-- vim.api.nvim_create_autocmd("BufEnter", {
--     pattern = "*",
--     callback = on_buf_enter,
-- })
--
-- -- Navigate backward in history
-- local function go_back()
--     prune_history()
--
--     if #buf_history <= 1 or current_index <= 1 then
--         vim.notify("No previous buffer in history", vim.log.levels.WARN)
--         return
--     end
--
--     current_index = current_index - 1
--     local target_buf = buf_history[current_index]
--
--     vim.notify("Going back to buffer at index " .. current_index, vim.log.levels.DEBUG)
--
--     if vim.api.nvim_buf_is_valid(target_buf) then
--         is_navigating = true
--         vim.api.nvim_set_current_buf(target_buf)
--     else
--         vim.notify("Cannot navigate to invalid buffer", vim.log.levels.WARN)
--         prune_history()
--     end
-- end
--
-- -- Navigate forward in history
-- local function go_forward()
--     prune_history()
--
--     if #buf_history <= 1 or current_index >= #buf_history then
--         vim.notify("No next buffer in history", vim.log.levels.WARN)
--         return
--     end
--
--     current_index = current_index + 1
--     local target_buf = buf_history[current_index]
--
--     vim.notify("Going forward to buffer at index " .. current_index, vim.log.levels.DEBUG)
--
--     if vim.api.nvim_buf_is_valid(target_buf) then
--         is_navigating = true
--         vim.api.nvim_set_current_buf(target_buf)
--     else
--         vim.notify("Cannot navigate to invalid buffer", vim.log.levels.WARN)
--         prune_history()
--     end
-- end
--
-- vim.keymap.set("n", "<C-Tab>", go_back, { noremap = true, silent = true })
-- vim.keymap.set("n", "<S-Tab>", go_forward, { noremap = true, silent = true })



