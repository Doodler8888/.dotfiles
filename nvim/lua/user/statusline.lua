-- lua/plugins/lualine.lua

-- =================================================================== --
--  1. Custom Component for Project-Wide Diagnostics                 --
-- =================================================================== --
-- This logic remains the same. Lualine will handle caching and performance.
local function get_lsp_project_root(bufnr)
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  if not clients or #clients == 0 then return nil end
  for _, client in ipairs(clients) do
    if client.root_dir then return client.root_dir end
  end
end

local function project_diagnostics()
  local bufnr = vim.api.nvim_get_current_buf()
  local project_root = get_lsp_project_root(bufnr)
  if not project_root then return '' end

  local total = { errors = 0, warnings = 0, hints = 0 }
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(b) and get_lsp_project_root(b) == project_root then
      local diag = vim.diagnostic.count(b)
      total.errors = total.errors + (diag[1] or 0)
      total.warnings = total.warnings + (diag[2] or 0)
      total.hints = total.hints + (diag[4] or 0)
    end
  end

  local parts = {}
  if total.errors > 0 then table.insert(parts, 'E:' .. total.errors) end
  if total.warnings > 0 then table.insert(parts, 'W:' .. total.warnings) end
  if total.hints > 0 then table.insert(parts, 'H:' .. total.hints) end
  if #parts == 0 then return '' end

  local local_diag = vim.diagnostic.count(bufnr)
  local local_errors = local_diag[1] or 0
  local local_warnings = local_diag[2] or 0
  if total.errors == local_errors and total.warnings == local_warnings then
    return ''
  end

  return '(' .. table.concat(parts, ' ') .. ')'
end

-- =================================================================== --
--  2. Main Lualine Configuration (Cleaned Up)                       --
-- =================================================================== --
local lualine_setup = {
  options = {
    theme = 'auto',
    component_separators = { left = ' ', right = ' '},
    section_separators = { left = '', right = ''},
    disabled_filetypes = { 'statusline', 'winbar' },
  },
  -- Define the layout for ACTIVE windows
  sections = {
    lualine_a = {
      -- Add the window number, just like in your original implementation
      function()
        return tostring(vim.api.nvim_win_get_number(0))
      end
    },
    lualine_b = { 'branch' },
    lualine_c = { { 'filename', path = 1 } }, -- Relative path
    lualine_x = {}, -- Empty middle section
    lualine_y = {
      { 'diagnostics', symbols = { error = 'E:', warn = 'W:', hint = 'H:' } },
      project_diagnostics, -- Our custom component
    },
    lualine_z = {}, -- Empty right-most section
  },
}

-- Apply the same layout to INACTIVE windows
lualine_setup.inactive_sections = lualine_setup.sections

require('lualine').setup(lualine_setup)
