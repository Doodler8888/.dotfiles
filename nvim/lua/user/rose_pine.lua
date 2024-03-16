require('rose-pine').setup({
	-- --- @usage 'auto'|'main'|'moon'|'dawn'
	variant = 'main',
	--- @usage 'main'|'moon'|'dawn'
	dark_variant = 'main',
	bold_vert_split = false,
	dim_nc_background = false,

	styles = {
	  transparency = true,
	  -- bold = false,
	  -- italic = false,
	},

	--- @usage string hex value or named color from rosepinetheme.com/palette
	groups = {
		-- background = 'base',
		background_nc = '_experimental_nc',
		panel = 'surface',
		panel_nc = 'base',
		border = 'highlight_med',
		comment = 'muted',
		link = 'iris',
		punctuation = 'subtle',

		error = 'love',
		hint = 'iris',
		info = 'foam',
		warn = 'gold',

		headings = {
			h1 = 'iris',
			h2 = 'foam',
			h3 = 'rose',
			h4 = 'gold',
			h5 = 'pine',
			h6 = 'foam',
		}
		-- or set all headings at once
		-- headings = 'subtle'
	},

	-- Change specific vim highlight groups
	-- https://github.com/rose-pine/neovim/wiki/Recipes
	highlight_groups = {
		ColorColumn = { bg = 'subtle', blend = 35, bold = false },
		-- CursorLine = { bg = 'foam', blend = 10, bold = false },
		-- CursorLineLn = { bg = 'foam', blend = 10, bold = false },
		StatusLine = { fg = 'love', bg = 'love', blend = 10, bold = false },
		StatusLineNC = { link = "StatusLine", bold = false },
		FloatBorder = { fg = 'highlight_med', bg = 'none', bold = false },
		TabLine = { bg = 'none', bold = false },
		TabLineFill = { bg = 'none', bold = false },
		TabLineSel = { bg = 'muted', blend = 25, bold = false },
		Title = { bold = false }, -- responsible for the split counter
		MatchParen = { bg = 'muted', fg = 'muted' },
		Search = { link = "Visual" },
		Substitute = { link = "Visual" },
		CurSearch = { link = "Visual" },
		-- TermCursor = { link = "Visual" },
		Directory = { fg = 'foam', bold = false },
		NotificationInfo = { bg = 'none', fg = '#e0def4' },
		NotificationError = { bg = 'none', fg = '#e0def4' },
		NotificationWarning = { bg = 'none', fg = '#e0def4' },
		TelescopeSelection = { fg = 'none', bg = 'subtle', blend = 18 },
		TroubleNormal = { fg = 'none', bg = 'none' },
		TroubleCount = { fg = 'iris', bg = 'none' },
		TroubleIndent = { fg = '#1d1f21', bg = 'none' },
}
})

-- Set colorscheme after options
vim.cmd('colorscheme rose-pine')

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local bold = false
    local italic = false
    local filetypes = {"norg", "markdown"}
    if vim.tbl_contains(filetypes, vim.bo.filetype) then
      bold = true
      italic = true
    end
    require("rose-pine").setup({
      styles = { bold = bold, italic = italic },
    })
    vim.cmd('colorscheme rose-pine')
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.norg" },
  callback = function()
    vim.opt.ft = 'norg'
  end,
})
