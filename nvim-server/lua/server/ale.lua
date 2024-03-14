-- Function to toggle ALE
function _G.toggle_ale()
  if vim.g.ale_enabled == 1 then
    vim.cmd('ALEDisable')
  else
    vim.cmd('ALEEnable')
  end
end

-- Keymap to call the function
vim.api.nvim_set_keymap('n', '<leader>at', '<cmd>lua toggle_ale()<CR>', { noremap = true, silent = true })

vim.g.ale_linters = {
  lua = {},
  haskell = {},
  nim = {},
  go = {},
  yaml = {},
  terraform = {},
}

