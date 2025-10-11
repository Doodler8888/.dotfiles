-- Interactive search and replace across files
-- Add this to your Neovim config (e.g., ~/.config/nvim/lua/search-replace.lua)

local M = {}

function M.interactive_replace()
  -- Get search pattern
  local search_pattern = vim.fn.input('Search for: ')
  if search_pattern == '' then
    print('Search cancelled')
    return
  end

  -- Get replacement pattern (pre-filled with search pattern)
  local replace_pattern = vim.fn.input('Replace with: ', search_pattern)
  if replace_pattern == '' then
    print('Replace cancelled')
    return
  end

  -- Get file pattern
  local file_pattern = vim.fn.input('In files (e.g., **/*.lua, *.txt): ', '**/*')
  if file_pattern == '' then
    print('File pattern cancelled')
    return
  end

  -- Execute vimgrep
  local ok, err = pcall(function()
    vim.cmd('vimgrep /' .. vim.fn.escape(search_pattern, '/') .. '/g ' .. file_pattern)
  end)

  if not ok then
    print('No matches found or error occurred')
    return
  end

  -- Perform interactive replacement directly
  pcall(function()
    vim.cmd('cfdo %s/' .. vim.fn.escape(search_pattern, '/') .. '/' .. vim.fn.escape(replace_pattern, '/') .. '/gc | update')
  end)
end

-- Create a command to call the function
vim.api.nvim_create_user_command('InteractiveReplace', M.interactive_replace, {})

-- Optional: Add a keybinding
vim.keymap.set('n', '<leader>gr', M.interactive_replace, { desc = 'Search and Replace across files' })

return M
