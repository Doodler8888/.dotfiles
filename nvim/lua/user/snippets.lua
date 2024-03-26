function _G.insert_ansible_builtin()
  local str = 'ansible.builtin.'
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  -- Insert the text
  vim.api.nvim_buf_set_text(bufnr, cursor[1]-1, cursor[2], cursor[1]-1, cursor[2], {str})
  -- Calculate new cursor position: current position + length of inserted string
  local new_cursor_pos = cursor[2] + #str
  -- Set the cursor to the new position
  vim.api.nvim_win_set_cursor(0, {cursor[1], new_cursor_pos})
end

-- vim.api.nvim_set_keymap('n', '<Leader>oa', ':lua insert_ansible_builtin()<CR>', {noremap = true})
-- vim.api.nvim_set_keymap('i', '<C-a>', '<Cmd>lua insert_ansible_builtin()<CR>', {noremap = true, silent = true})


function _G.insert_general_community()
  local str = 'general.community.'
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_buf_set_text(bufnr, cursor[1]-1, cursor[2], cursor[1]-1, cursor[2], {str})
  vim.api.nvim_win_set_cursor(0, cursor)
end

-- vim.api.nvim_set_keymap('n', '<Leader>oc', ':lua insert_general_community()<CR>', {noremap = true})


-- vim.keymap.set(
--     "n",
--     "<leader>ee",
--     "oif err != nil {<CR>}<Esc>Oreturn err<Esc>"
-- )
