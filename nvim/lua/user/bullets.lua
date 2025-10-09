vim.g.bullets_set_mappings = 0  -- Disable default mappings

-- Then set up your own mappings
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text" },
  callback = function()
    -- Normal Enter: just new line (like M-RET in org-mode)
    vim.keymap.set('i', '<CR>', '<CR>', { buffer = true })

    -- Alt-Enter or Ctrl-Enter: create new bullet
    vim.keymap.set('i', '<M-CR>', '<Plug>(bullets-newline)', { buffer = true })
    -- Or use Ctrl-Enter if you prefer:
    -- vim.keymap.set('i', '<C-CR>', '<Plug>(bullets-newline)', { buffer = true })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text" },
  callback = function()
    vim.keymap.set({'n', 'v'}, '<C-c><C-c>', '<Plug>(bullets-toggle-checkbox)', { buffer = true })
  end,
})
