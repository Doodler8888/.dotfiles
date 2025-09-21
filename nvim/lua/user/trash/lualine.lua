-- Simple statusline configuration - just paste this in your init.lua

-- Function to get git branch name for a specific buffer
function _G.get_git_branch(bufnr)
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  if filepath == "" then
    return ""
  end

  local dir = vim.fn.fnamemodify(filepath, ":h")
  local handle = io.popen("cd " .. vim.fn.shellescape(dir) .. " && git branch --show-current 2>/dev/null")
  if handle then
    local branch = handle:read("*a"):gsub("\n", "")
    handle:close()
    if branch and branch ~= "" then
      return "[" .. branch .. "]"
    end
  end
  return ""
end

-- Function to get LSP diagnostics for a specific buffer
function _G.get_lsp_diagnostics(bufnr)
  if not vim.diagnostic then
    return ""
  end

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

-- Build statusline for a specific window
function _G.build_statusline()
  local winid = vim.g.statusline_winid or vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_win_get_buf(winid)

  local parts = {}

  -- Window number
  table.insert(parts, vim.api.nvim_win_get_number(winid))

  -- Relative path to pwd
  local filepath = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':~:.')
  if filepath == '' then
    filepath = '[No Name]'
  end
  table.insert(parts, filepath)

  -- Git branch
  local branch = get_git_branch(bufnr)
  if branch ~= "" then
    table.insert(parts, branch)
  end

  -- LSP diagnostics at the end
  local diagnostics = get_lsp_diagnostics(bufnr)
  local left_side = table.concat(parts, " ")

  if diagnostics ~= "" then
    return left_side .. "%=" .. diagnostics
  else
    return left_side
  end
end

-- Set the statusline
vim.opt.statusline = "%!v:lua.build_statusline()"
