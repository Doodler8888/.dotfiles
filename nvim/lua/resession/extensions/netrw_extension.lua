local M = {}

M.is_win_supported = function(winid, bufnr)
  return vim.bo[bufnr].filetype == "netrw"
end

M.save_win = function(winid)
  local bufnr = vim.api.nvim_win_get_buf(winid)
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  return { bufname = bufname }
end

M.load_win = function(winid, config)
  vim.cmd("edit " .. config.bufname)
end

return M
