-- Simple statusline configuration - just paste this in your init.lua

-- Function to get git branch name for current buffer
function _G.get_git_branch()
  local handle = io.popen("git branch --show-current 2>/dev/null")
  if handle then
    local branch = handle:read("*a"):gsub("\n", "")
    handle:close()
    if branch and branch ~= "" then
      return "[" .. branch .. "]"
    end
  end
  return ""
end

-- Function to get LSP diagnostics for current buffer
function _G.get_lsp_diagnostics()
  if not vim.diagnostic then
    return ""
  end

  local bufnr = vim.fn.bufnr('%')
  local diagnostics = vim.diagnostic.get(bufnr)

  local errors = 0
  local warnings = 0

  for _, diagnostic in ipairs(diagnostics) do
    if diagnostic.severity == vim.diagnostic.severity.ERROR then
      errors = errors + 1
    elseif diagnostic.severity == vim.diagnostic.severity.WARN then
      warnings = warnings + 1
    end
  end

  local result = ""
  if errors > 0 then
    result = result .. "E:" .. errors
  end
  if warnings > 0 then
    if result ~= "" then
      result = result .. " "
    end
    result = result .. "W:" .. warnings
  end

  return result
end

-- Set the statusline using format strings that evaluate per window
vim.opt.statusline = "%{winnr()} %F %{v:lua.get_git_branch()} %=%{v:lua.get_lsp_diagnostics()}"

-- Auto command to refresh statusline when LSP diagnostics change
vim.api.nvim_create_autocmd("DiagnosticChanged", {
  callback = function()
    vim.cmd("redrawstatus")
  end
})
