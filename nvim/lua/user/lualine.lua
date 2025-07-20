require('lualine').setup({
  options = {
    theme = 'rose-pine',
    icons_enabled = true,
    component_separators = { left = ' ', right = ' ' },
    section_separators = { left = ' ', right = ' ' },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {},
    lualine_b = {
      {
        'filename',
        path = 1,
      },
      -- Use our custom function instead of the default 'branch' component
      get_git_branch,
    },
    lualine_c = {
      'diagnostics',
    },
    lualine_x = {
      {
        'filetype',
        colored = true,
        icon_only = false,
      }
    },
    lualine_y = {},
    lualine_z = {},
  },
  inactive_sections = {
    -- Also use the custom function here to ensure it works on all windows
    lualine_a = {},
    lualine_b = {
      {
        'filename',
        path = 1,
      },
      get_git_branch,
    },
    lualine_c = {
      'diagnostics',
    },
    lualine_x = {
      {
        'filetype',
        colored = true,
        icon_only = false,
      }
    },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {},
})
