-- user/statusline.lua
-- Robust, event-driven statusline that shows paths relative to Neovim's CWD

local M = {}

-- Return a buffer's path relative to the current working directory
function M.relative_path(bufnr)
  bufnr = bufnr or 0
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" then
    return "[No Name]"
  end
  -- ':.' makes the path relative to vim.fn.getcwd()
  return vim.fn.fnamemodify(name, ':.')
end

-- Diagnostic counts: local vs global
local function calculate_diagnostic_string(bufnr)
  if not bufnr or not vim.api.nvim_buf_is_valid(tonumber(bufnr)) then
    return ""
  end
  local local_errors = vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR })
  local local_warnings = vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.WARN })
  local global_errors = vim.diagnostic.get(nil, { severity = vim.diagnostic.severity.ERROR })
  local global_warnings = vim.diagnostic.get(nil, { severity = vim.diagnostic.severity.WARN })
  local err_str = (#local_errors > 0 or #global_errors > 0) and
    ("E:" .. #local_errors .. "(" .. #global_errors .. ")") or ""
  local warn_str = (#local_warnings > 0 or #global_warnings > 0) and
    ("W:" .. #local_warnings .. "(" .. #global_warnings .. ")") or ""
  if err_str ~= "" and warn_str ~= "" then
    return err_str .. " " .. warn_str
  end
  return err_str .. warn_str
end

-- Get current Git branch, wrapped in []
local function calculate_git_branch()
  local branch = vim.fn['gitbranch#name']()
  return branch ~= '' and '[' .. branch .. ']' or ''
end

-- Update statusline variables for the current window
function M.update_status()
  local bufnr = vim.fn.bufnr('%')
  vim.w.statusline_diagnostics = calculate_diagnostic_string(bufnr)
  vim.w.statusline_git = calculate_git_branch()
end

-- Update statusline variables for all visible windows
function M.update_all_windows_status()
  local git_str = calculate_git_branch()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local bufnr = vim.api.nvim_win_get_buf(win)
    if vim.api.nvim_buf_is_loaded(bufnr) then
      vim.fn.setwinvar(win, 'statusline_diagnostics', calculate_diagnostic_string(bufnr))
      vim.fn.setwinvar(win, 'statusline_git', git_str)
    end
  end
  vim.cmd('redrawstatus')
end

-- Single-setup function, run once on VimEnter
local function setup_statusline_once()
  vim.o.statusline = table.concat({
    '%{winnr()}', ' ',
    '%{luaeval("require(\'user.statusline\').relative_path()")}', ' ',
    '%{get(w:, "statusline_git", "")}',
    '%=', '%{get(w:, "statusline_diagnostics", "")}', ' '
  }, '')

  -- Create autocmd group
  vim.api.nvim_create_augroup('custom_statusline_updater', { clear = true })

  -- Update on window/buffer enter
  vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, {
    group = 'custom_statusline_updater',
    pattern = '*',
    callback = function()
      require('user.statusline').update_status()
    end,
  })

  -- Update on diagnostic changes
  vim.api.nvim_create_autocmd('DiagnosticChanged', {
    group = 'custom_statusline_updater',
    callback = function()
      vim.schedule(M.update_all_windows_status)
    end,
  })

  -- Initial update
  vim.schedule(M.update_all_windows_status)
end

-- Trigger setup after VimEnter
vim.api.nvim_create_autocmd('VimEnter', {
  pattern = '*',
  once = true,
  callback = setup_statusline_once,
})

return M
