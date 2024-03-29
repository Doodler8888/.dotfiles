local M = {}

-- Check if the window's buffer has any folds to be considered for saving.
M.is_win_supported = function(winid, bufnr)
  -- Assuming every window is supported as long as it can have folds.
  -- You might want to add additional checks here depending on your requirements.
  return true
end

-- Save the fold information of the window's buffer.
M.save_win = function(winid)
  local bufnr = vim.api.nvim_win_get_buf(winid)
  local folds = {}

  -- Iterate through each line in the buffer to save folds.
  local line_count = vim.api.nvim_buf_line_count(bufnr)
  for i = 1, line_count do
    local foldclosed = vim.fn.foldclosed(i)
    if foldclosed > -1 then
      -- Only save the start of each fold.
      if not vim.tbl_contains(folds, foldclosed) then
        table.insert(folds, {foldclosed, vim.fn.foldclosedend(i)})
      end
      i = vim.fn.foldclosedend(i) -- Skip to the end of the fold to avoid redundant checks.
    end
  end

  return { folds = folds }
end

-- Load the fold information into the window's buffer.
M.load_win = function(winid, config)
  local bufnr = vim.api.nvim_win_get_buf(winid)
  vim.api.nvim_buf_set_option(bufnr, 'modifiable', true)

  -- Apply the saved folds.
  for _, fold in ipairs(config.folds) do
    local start_line, end_line = unpack(fold)
    vim.api.nvim_buf_set_lines(bufnr, start_line-1, end_line, false, {"{{{1"}})
  end

  vim.api.nvim_buf_set_option(bufnr, 'modifiable', false)
  vim.cmd('normal! zx') -- Recalculate folds
end

return M
