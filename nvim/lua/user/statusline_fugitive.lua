local function GetLspProjectRoot(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
  if not clients or #clients == 0 then
    return nil
  end
  -- Return the root_dir of the first client. In most cases, all clients
  -- for a buffer share the same root directory.
  for _, client in ipairs(clients) do
    if client.root_dir then
      return client.root_dir
    end
  end
  return nil
end

-- Function to get Git branch using Vim-fugitive
local function GetGitBranch()
  if vim.fn.exists('*FugitiveHead') == 0 then
    return ''
  end
  local branch = vim.fn.FugitiveHead()
  if branch and #branch > 0 then
    return '[' .. branch .. ']'
  end
  return ''
end

-- Function to format the file path relative to the window's working directory
local function FormatFilePath(winid)
  winid = winid or vim.api.nvim_get_current_win()
  local bufnr  = vim.api.nvim_win_get_buf(winid)
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  if bufname == '' then
    return '[No Name]'
  end

  local cwd = vim.fn.getcwd(vim.api.nvim_win_get_number(winid))
  local fullpath = vim.fn.fnamemodify(bufname, ':p')

  if fullpath:find('^' .. vim.pesc(cwd)) then
    return fullpath:sub(#cwd + 2)
  else
    return vim.fn.fnamemodify(fullpath, ':~')
  end
end

-- Count diagnostics in a single buffer (local scope)
local function GetDiagnosticString(bufnr)
  local counts = vim.diagnostic.count(bufnr)
  if not counts or vim.tbl_isempty(counts) then
    return ''
  end

  local parts = {}
  if counts[1] and counts[1] > 0 then table.insert(parts, 'E:'..counts[1]) end
  if counts[2] and counts[2] > 0 then table.insert(parts, 'W:'..counts[2]) end
  if counts[4] and counts[4] > 0 then table.insert(parts, 'H:'..counts[4]) end
  return table.concat(parts, ' ')
end

-- **MODIFIED**: Count diagnostics scoped to the buffer's LSP project root.
local function GetProjectDiagnosticString(bufnr)
  local current_project_root = GetLspProjectRoot(bufnr)
  if not current_project_root then return '' end

  local total = { [1]=0, [2]=0, [4]=0 }
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(b) then
      -- Check if this buffer belongs to the same LSP project
      local b_root = GetLspProjectRoot(b)
      if b_root and b_root == current_project_root then
        local c = vim.diagnostic.count(b)
        if c then
          for sev, num in pairs(c) do
            if total[sev] then total[sev] = total[sev] + num end
          end
        end
      end
    end
  end

  local parts = {}
  if total[1] > 0 then table.insert(parts, 'E:'..total[1]) end
  if total[2] > 0 then table.insert(parts, 'W:'..total[2]) end
  if total[4] > 0 then table.insert(parts, 'H:'..total[4]) end
  return table.concat(parts, ' ')
end


-- **MODIFIED**: Combine local + project diags, with improved display logic
local function CombinedDiagnosticStatus(winid)
  winid = winid or vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_win_get_buf(winid)

  local local_str   = GetDiagnosticString(bufnr)
  local project_str = GetProjectDiagnosticString(bufnr)

  -- Case 1: No project diagnostics exist at all.
  -- Only show local diagnostics (which might also be empty).
  if project_str == '' then
    return local_str
  end

  -- Case 2: Project has diagnostics, but the current buffer is clean.
  -- Show the project count in parentheses.
  if local_str == '' then
    return '(' .. project_str .. ')'
  end

  -- Case 3: Both have diagnostics, but they are identical (e.g., only one file with errors).
  -- Just show the count once to avoid redundancy like "E:1 (E:1)".
  if local_str == project_str then
    return local_str
  end

  -- Case 4: Both have diagnostics and they are different.
  -- Show the full "local (project)" format.
  return local_str .. ' (' .. project_str .. ')'
end


-- The main statusline function, evaluated per-window
function StatuslineForWindow()
  local winid     = vim.api.nvim_get_current_win()
  local winnr     = vim.api.nvim_win_get_number(winid)
  local filepath  = FormatFilePath(winid)
  local branch    = GetGitBranch()
  local diags     = CombinedDiagnosticStatus(winid)

  local left      = winnr .. ' ' .. filepath .. ' ' .. branch
  local right     = ' ' .. diags -- Add a leading space for padding
  return left .. '%=' .. right
end

-- =================================================================== --
--  Autocmds to keep each window’s statusline live (Unchanged)         --
-- =================================================================== --

local aug = vim.api.nvim_create_augroup("UserStatuslineDiagnostics", { clear = true })

vim.api.nvim_create_autocmd("DiagnosticChanged", {
  group    = aug,
  callback = function()
    vim.cmd('redrawstatus')
  end,
})

vim.api.nvim_create_autocmd({ "DirChanged", "BufEnter", "WinEnter" }, {
  group    = aug,
  callback = function()
    vim.cmd('redrawstatus')
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_option(win, 'statusline', '%{%v:lua.StatuslineForWindow()%}')
  end,
})
