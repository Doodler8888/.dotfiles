-- Function to toggle ALE
function _G.toggle_ale()
  if vim.g.ale_enabled == 1 then
    vim.cmd('ALEDisable')
  else
    vim.cmd('ALEEnable')
  end
end

vim.api.nvim_set_keymap('n', '<leader>at', '<cmd>lua toggle_ale()<CR>', { noremap = true, silent = true })

vim.g.ale_linters = {
  lua = {},
  haskell = {},
  nim = {},
  go = {},
  yaml = {'ansible-lint'},
  terraform = {},
  rust = {},
  python = {},
  sql = {'sqlfluff'},
  -- python = {'flake8'},
  -- ansible = {''},
}

vim.g.ale_linters_ignore = {
  -- go = {'golangci-lint'},
}

vim.g.ale_lint_on_text_changed = 'always'

vim.g.ale_python_flake8_options = '--max-line-length=100 --ignore=E203,W503'
