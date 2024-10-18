require('lint').linters_by_ft = {
  -- markdown = {'vale',}
  ['yaml.ansible'] = {'ansible_lint',},
  dockerfile = {'hadolint',},
  sh = {'shellcheck',},
  -- ['yaml.kubernetes'] = {'kube_linter'},
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    require("lint").try_lint()
  end,
})

-- Lint on opening a file
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  callback = function()
    require("lint").try_lint()
  end,
})
