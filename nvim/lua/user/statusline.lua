-- Function to get Git branch using Vim-fugitive
function GetGitBranch()
    local branch = vim.fn.FugitiveHead()
    if branch and #branch > 0 then
        return '[' .. branch .. ']'
    end
    return ''
end

-- Function to format the file path relative to the current directory (tcd/lcd)
function FormatFilePath()
  local file_path = vim.fn.fnamemodify(vim.fn.expand('%'), ':.')
  if file_path == '' then
    return '[No Name]'
  end
  if file_path:sub(1, 1) == '/' then
    file_path = vim.fn.fnamemodify(file_path, ':~')
  end
  return file_path
end


--- Helper function to get and format a diagnostic string.
function GetDiagnosticString(bufnr)
  local counts = vim.diagnostic.count(bufnr)
  if not counts then return '' end
  local severities = {
    { 'E', vim.diagnostic.severity.ERROR },
    { 'W', vim.diagnostic.severity.WARN },
    { 'H', vim.diagnostic.severity.HINT },
  }
  local parts = {}
  for _, s in ipairs(severities) do
    local name = s[1]
    local level = s[2]
    if counts[level] and counts[level] > 0 then
      table.insert(parts, string.format('%s:%d', name, counts[level]))
    end
  end
  return table.concat(parts, ' ')
end

--- Formats local and global diagnostics with the parenthesis rule.
function CombinedDiagnosticStatus()
  local local_diagnostics = GetDiagnosticString(0) -- for current file
  local global_diagnostics = GetDiagnosticString(nil) -- for all files
  if global_diagnostics == '' then
    return ''
  end
  if local_diagnostics == '' then
    return '(' .. global_diagnostics .. ')'
  end
  if local_diagnostics == global_diagnostics then
    return local_diagnostics
  end
  return string.format('%s (%s)', local_diagnostics, global_diagnostics)
end

-- Set the statusline
local left_side = '%{winnr()} %{%v:lua.FormatFilePath()%} %{%v:lua.GetGitBranch()%}'
local right_side = '%{%v:lua.CombinedDiagnosticStatus()%}'

vim.o.statusline = left_side .. '%=' .. right_side

-- =================================================================== --
--  IMPORTANT: Autocommand to update statusline on diagnostic change   --
-- =================================================================== --
local diag_augroup = vim.api.nvim_create_augroup("UserStatuslineDiagnostics", { clear = true })

vim.api.nvim_create_autocmd("DiagnosticChanged", {
  group = diag_augroup,
  pattern = "*",
  command = "redrawstatus!",
})
