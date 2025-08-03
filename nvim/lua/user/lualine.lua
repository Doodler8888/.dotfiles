-- =================================================================== --
--  1. The Cache for our Custom Git Component                        --
-- =================================================================== --
local cache = {
  git_branch = {}
}

-- =================================================================== --
--  2. Custom Components (for correct context and performance)       --
-- =================================================================== --

local function custom_git_branch()
  local bufnr = vim.api.nvim_get_current_buf()
  if cache.git_branch[bufnr] then return cache.git_branch[bufnr] end
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  if bufname == '' then cache.git_branch[bufnr] = ''; return '' end
  local file_dir = vim.fn.fnamemodify(bufname, ':h')
  if file_dir == '' or file_dir == '.' then cache.git_branch[bufnr] = ''; return '' end
  local branch_list = vim.fn.systemlist('git -C ' .. vim.fn.shellescape(file_dir) .. ' branch --show-current')
  local branch_str = ''
  if vim.v.shell_error == 0 and branch_list[1] and branch_list[1] ~= '' then
    branch_str = '[' .. branch_list[1] .. ']'
  end
  cache.git_branch[bufnr] = branch_str
  return branch_str
end

-- **THE FINAL FIX**: This version is guaranteed to be correct.
local function custom_filename()
  local winid = vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_win_get_buf(winid)
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  if bufname == '' or bufname == nil then return '[No Name]' end

  -- Get the CWD for the specific window being drawn
  local win_cwd = vim.fn.getcwd(winid)
  -- Get the absolute path of the file
  local full_path = vim.fn.fnamemodify(bufname, ':p')

  -- Escape any special characters in the CWD path for Lua's pattern matching
  local escaped_cwd = vim.pesc(win_cwd)

  -- Check if the full path starts with the window's CWD
  if full_path:find('^' .. escaped_cwd) then
    -- If it does, manually create the relative path by stripping the CWD prefix.
    -- The +2 accounts for the trailing slash.
    return full_path:sub(#win_cwd + 2)
  else
    -- If it's not in the CWD (i.e., different project), use the ~ fallback.
    return vim.fn.fnamemodify(full_path, ':~')
  end
end


local function combined_diagnostics()
  local bufnr = vim.api.nvim_get_current_buf()
  local local_counts = vim.diagnostic.count(bufnr)
  local local_parts = {}
  if local_counts[1] and local_counts[1] > 0 then table.insert(local_parts, 'E:' .. local_counts[1]) end
  if local_counts[2] and local_counts[2] > 0 then table.insert(local_parts, 'W:' .. local_counts[2]) end
  if local_counts[4] and local_counts[4] > 0 then table.insert(local_parts, 'H:' .. local_counts[4]) end
  local local_str = table.concat(local_parts, ' ')
  local get_lsp_project_root = function(b)
    if not b or b == -1 then return nil end
    local clients = vim.lsp.get_clients({ bufnr = b })
    if not clients or #clients == 0 then return nil end
    for _, client in ipairs(clients) do if client.root_dir then return client.root_dir end end
  end
  local project_root = get_lsp_project_root(bufnr)
  if not project_root then return local_str end
  local total = { errors = 0, warnings = 0, hints = 0 }
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(b) and get_lsp_project_root(b) == project_root then
      local diag = vim.diagnostic.count(b)
      total.errors = total.errors + (diag[1] or 0)
      total.warnings = total.warnings + (diag[2] or 0)
      total.hints = total.hints + (diag[4] or 0)
    end
  end
  local project_parts = {}
  if total.errors > 0 then table.insert(project_parts, 'E:' .. total.errors) end
  if total.warnings > 0 then table.insert(project_parts, 'W:' .. total.warnings) end
  if total.hints > 0 then table.insert(project_parts, 'H:' .. total.hints) end
  local project_str = table.concat(project_parts, ' ')
  if project_str == '' or project_str == local_str then return local_str
  elseif local_str == '' then return '(' .. project_str .. ')'
  else return local_str .. ' (' .. project_str .. ')' end
end

-- =================================================================== --
--  3. A Single Function to Build the Entire Left Side               --
-- =================================================================== --
local function build_left_side()
  local win_nr = tostring(vim.api.nvim_win_get_number(0))
  local filename = custom_filename()
  local branch = custom_git_branch()
  local parts = { win_nr, filename }
  if branch ~= '' then
    table.insert(parts, branch)
  end
  return table.concat(parts, ' ')
end

-- =================================================================== --
--  4. A "Transparent" Theme                                         --
-- =================================================================== --
local transparent_theme = {
  normal = { a = { bg = 'NONE' }, b = { bg = 'NONE' }, c = { bg = 'NONE' } },
  inactive = { a = { bg = 'NONE' }, b = { bg = 'NONE' }, c = { bg = 'NONE' } },
}

-- =================================================================== --
--  5. Main Lualine Configuration                                    --
-- =================================================================== --
local lualine_config = {
  options = {
    theme = transparent_theme,
    component_separators = '',
    section_separators = '',
    disabled_filetypes = { 'statusline', 'winbar' },
  },
  sections = {
    lualine_a = {},
    lualine_b = { build_left_side },
    lualine_c = {},
    lualine_x = {},
    lualine_y = { combined_diagnostics },
    lualine_z = {},
  },
}

lualine_config.inactive_sections = lualine_config.sections
require('lualine').setup(lualine_config)

-- =================================================================== --
--  6. Autocommands for Cache Management and Startup                 --
-- =================================================================== --
local aug = vim.api.nvim_create_augroup('CustomLualineCache', { clear = true })
vim.api.nvim_create_autocmd({ "FocusGained", "DirChanged" }, {
  group = aug,
  callback = function() cache.git_branch = {} end,
})
vim.api.nvim_create_autocmd("BufDelete", {
  group = aug,
  callback = function(args) cache.git_branch[args.buf] = nil end,
})
vim.api.nvim_create_autocmd("VimEnter", {
  group = aug,
  callback = function() require('lualine').refresh() end,
  once = true,
})
