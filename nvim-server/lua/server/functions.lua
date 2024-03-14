function Copy_full_path()
    local full_path = vim.fn.expand('%:p')
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


-- local function change_to_buffer_dir()
--   -- Get the current buffer's full path
--   local bufname = vim.api.nvim_buf_get_name(0)
--   -- Extract the directory from the buffer's full path
--   local buftdir = vim.fn.fnamemodify(bufname, ':p:h')
--   -- Change the Neovim's current working directory to the buffer's directory
--   vim.cmd('cd ' .. buftdir)
-- end

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
    -- Extract the directory from the buffer's full path
    buftdir = vim.fn.fnamemodify(bufname, ':p:h')
  end

  -- Change Neovim's current working directory to the buffer's directory
  vim.cmd('cd ' .. buftdir)
end

-- Create a Neovim command called "CdToBufferDir" that invokes the function
vim.api.nvim_create_user_command('Cd', change_to_buffer_dir, {})


function Print_diagnostics_to_buffer()
  -- Create a new buffer
  local bufnr = vim.api.nvim_create_buf(false, true)

  -- Get the diagnostics from the LSP
  local diagnostics = vim.lsp.diagnostic.get()

  -- Open the new buffer in a new split
  vim.api.nvim_command("split | buffer " .. bufnr)

  -- Iterate over the diagnostics and print them into the new buffer
  for _, diagnostic in ipairs(diagnostics) do
      for _, item in ipairs(diagnostic.items) do
          local msg = string.format("%s: %s", item.source, item.message)
          vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, {msg})
      end
  end
end

-- Bind the function to the key combination <leader>d
vim.api.nvim_set_keymap('n', '<leader>dd', ':lua Print_diagnostics_to_buffer()<CR>', { noremap = true, silent = true })


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
