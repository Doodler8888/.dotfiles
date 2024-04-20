require('rose-pine').setup({
	-- --- @usage 'auto'|'main'|'moon'|'dawn'
	variant = 'main',
	--- @usage 'main'|'moon'|'dawn'
	dark_variant = 'main',
	bold_vert_split = false,
	dim_nc_background = false,

	styles = {
	  transparency = true,
	  bold = false,
	  italic = false,
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
		TelescopeNormal = { fg = '#e0def4', bg = 'none' },
		TelescopeSelection = { fg = 'none', bg = 'subtle', blend = 18 },
		TroubleNormal = { fg = 'none', bg = 'none' },
		TroubleCount = { fg = 'iris', bg = 'none' },
		TroubleIndent = { fg = '#1d1f21', bg = 'none' },
                ['@neorg.markup.italic.norg'] = { italic = true },
                ['@neorg.markup.bold.norg'] = { bold = true },
                ['@markup.italic.markdown_inline'] = { italic = true },
                ['@markup.strong.markdown_inline'] = { bold = true },
}
})

vim.api.nvim_set_hl(0, '@string.special.symbol.clojure', { link = 'Identifier' })
vim.api.nvim_set_hl(0, '@lsp.type.macro.clojure', { link = '@constant.macro' })
vim.api.nvim_set_hl(0, '@type.clojure', { link = '@type' })
vim.api.nvim_set_hl(0, '@function.call.clojure', { link = '@function' })
vim.api.nvim_set_hl(0, '@function.method.clojure', { link = '@function.method' })

-- @function.method.clojure links to @function.method

-- Customize Identifier for Clojure files
vim.api.nvim_create_autocmd("FileType", {
    pattern = "clojure",
    callback = function()
        vim.cmd("highlight Identifier guifg=#c4a7e7")
        vim.cmd("highlight Keyword guifg=#9ccfd8")
        vim.cmd("highlight @constant.macro guifg=#31748f")
        vim.cmd("highlight @type guifg=#c4a7e7")
        vim.cmd("highlight @function guifg=#ebbcba")
        vim.cmd("highlight @function.method guifg=#9ccfd8")
    end,
})

-- Set colorscheme after options
vim.cmd('colorscheme rose-pine')
