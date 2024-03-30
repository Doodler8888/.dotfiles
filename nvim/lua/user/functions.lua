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

vim.api.nvim_create_user_command('Cp', Copy_full_path, {})


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
  vim.cmd('lcd ' .. buftdir)
end

-- Create a Neovim command called "CdToBufferDir" that invokes the function
vim.api.nvim_create_user_command('Cd', change_to_buffer_dir, {})


function ShowMessagesInNewBuffer()
  -- Capture the output of the :messages command
  local messages_output = vim.api.nvim_exec('messages', true)
  local lines = {}
  for s in messages_output:gmatch("[^\r\n]+") do
    table.insert(lines, s)
  end

  -- Create a new buffer and open it in a new window
  vim.api.nvim_command('enew')
  local bufnr = vim.api.nvim_get_current_buf()

  -- Set buffer options to make it a scratch/temporary buffer
  vim.api.nvim_buf_set_option(bufnr, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(bufnr, 'bufhidden', 'hide')
  vim.api.nvim_buf_set_option(bufnr, 'swapfile', false)

  -- Make the buffer writable before putting the messages
  vim.api.nvim_buf_set_option(bufnr, 'modifiable', true)

  -- Insert the captured messages into the buffer
  vim.api.nvim_put(lines, '', false, true)

  -- Scroll to the start of the buffer
  vim.api.nvim_command('normal! gg')

  -- Finally, set the buffer to read-only to prevent editing
  vim.api.nvim_buf_set_option(bufnr, 'modifiable', false)
end

-- You can bind the function to a command in Neovim
vim.api.nvim_create_user_command('ShowMessages', ShowMessagesInNewBuffer, {})
vim.api.nvim_set_keymap('n', '<Leader>mm', ':ShowMessages<CR>', {noremap = true, silent = true})


-- Function to temporarily disable auto-indentation, insert a new line below, and then re-enable auto-indentation
function _G.insert_new_line_below()
 local auto_indent = vim.api.nvim_buf_get_option(0, 'autoindent')
 vim.api.nvim_buf_set_option(0, 'autoindent', false)
 vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('o<Esc>i', true, true, true), 'n', true)
 vim.api.nvim_buf_set_option(0, 'autoindent', auto_indent)
end

-- Function to temporarily disable auto-indentation, insert a new line above, and then re-enable auto-indentation
function _G.insert_new_line_above()
 local auto_indent = vim.api.nvim_buf_get_option(0, 'autoindent')
 vim.api.nvim_buf_set_option(0, 'autoindent', false)
 vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('O<Esc>i', true, true, true), 'n', true)
 vim.api.nvim_buf_set_option(0, 'autoindent', auto_indent)
end

-- Map <leader>o to insert a new line below without auto-indentation
vim.api.nvim_set_keymap('n', 'go', ':lua insert_new_line_below()<CR>', {noremap = true, silent = true})
-- Map <leader>O to insert a new line above without auto-indentation
vim.api.nvim_set_keymap('n', 'gO', ':lua insert_new_line_above()<CR>', {noremap = true, silent = true})


vim.g.zoxide_custom_action = {
  Z = {
    cmd = 'Oil',
    is_dir_only = true
  }
}


