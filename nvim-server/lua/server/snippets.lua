function _G.insert_ansible_builtin()
  local str = 'ansible.builtin.'
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_buf_set_text(bufnr, cursor[1]-1, cursor[2], cursor[1]-1, cursor[2], {str})
  vim.api.nvim_win_set_cursor(0, cursor)
end



vim.api.nvim_set_keymap('n', '<Leader>sa', ':lua insert_ansible_builtin()<CR>', {noremap = true})
