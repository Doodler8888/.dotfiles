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
		TelescopeMatching = { fg = 'none', bg = 'subtle', blend = 60 },
		TroubleNormal = { fg = 'none', bg = 'none' },
		TroubleCount = { fg = 'iris', bg = 'none' },
		TroubleIndent = { fg = '#1d1f21', bg = 'none' },
		-- QuickFixLine = { fg = '#e0def4', bg = 'subtle', blend = 18 },
		QuickFixLine = { fg = 'none', bg = 'subtle', blend = 18 },
		-- QuickFixLineNr = { fg = '#e0def4', bg = 'none', blend = 18 },
		-- QuickFixHeaderHard = { fg = '#e0def4', bg = 'none', blend = 18 },
		-- QuickFixHeaderSoft = { fg = '#e0def4', bg = 'none', blend = 18 },


		-- NeogitDiffContextHighlight = { fg = '#e0def4', bg = '#1d1f21' },
		-- NeogitDiffContextCursor = { fg = '#e0def4', bg = 'none' },
		-- NeogitHunkHeaderHighlight = { fg = 'iris', bg = '#1d1f21' },

		-- NeogitDiffContext = { fg = '#1d1f21', bg = 'none' },
		-- Background for diff folds
		-- NeogitDiffAdd = { fg = '#1d1f21', bg = 'none' },
		-- NeogitDiffAddHighlight = { fg = '#e0def4', bg = 'foam', blend = 10 },
		-- NeogitDiffAddCursor = { fg = '#1d1f21', bg = 'none' },
		-- NeogitDiffDelete = { fg = '#1d1f21', bg = 'none' },
		-- NeogitDiffDeleteHighlight = { fg = '#1d1f21', bg = 'none' },
		-- NeogitDiffDeleteCursor = { fg = '#1d1f21', bg = 'none' },
		-- NeogitDiffHeader = { fg = '#1d1f21', bg = 'none' },
		-- NeogitDiffHeaderHighlight = { fg = '#1d1f21', bg = 'none' },
		-- NeogitDiffHeaderCursor = { fg = '#1d1f21', bg = 'none' },
		-- NeogitHunkHeader = { fg = '#1d1f21', bg = 'none' },
		-- NeogitHunkHeaderCursor = { fg = '#1d1f21', bg = 'none' },

		-- NeogitChangeModified = { fg = '#e0def4', bg = 'none' },
		-- NeogitChangeAdded = { fg = '#e0def4', bg = 'none' },
		-- NeogitChangeDeleted = { fg = '#e0def4', bg = 'none' },
		-- NeogitChangeRenamed = { fg = '#e0def4', bg = 'none' },
		-- NeogitChangeUpdated = { fg = '#e0def4', bg = 'none' },
		-- NeogitChangeCopied = { fg = '#e0def4', bg = 'none' },
		-- NeogitChangeNewFile = { fg = '#e0def4', bg = 'none' },
		-- NeogitChangeUnmerged = { fg = '#e0def4', bg = 'none' },

		['@neorg.markup.italic.norg'] = { italic = true },
		['@neorg.markup.bold.norg'] = { bold = true },
		['@markup.italic.markdown_inline'] = { italic = true },
		['@markup.strong.markdown_inline'] = { bold = true },

		-- I probably don't need all of them. They were added because of url's in comment string had their own color.
		-- Also, if i try to change the highlighting like i did wit python below, then it will work very slow for some reason.
		['@comment.lua'] = { fg = 'muted' },
		['@spell.lua'] = { fg = 'muted' },
		['@string.special.url.comment'] = { fg = 'muted' },
		['@nospell.comment'] = { fg = 'muted' },
		['@lsp.type.comment.lua'] = { fg = 'muted' },
	      }
	    })

-- vim.api.nvim_set_hl(0, '@string.special.symbol.clojure', { link = 'Identifier' })
-- vim.api.nvim_set_hl(0, '@lsp.type.macro.clojure', { link = '@constant.macro' })
-- vim.api.nvim_set_hl(0, '@type.clojure', { link = '@type' })
-- vim.api.nvim_set_hl(0, '@function.call.clojure', { link = '@function' })
-- vim.api.nvim_set_hl(0, '@function.method.clojure', { link = '@function.method' })

vim.api.nvim_set_hl(0, '@number.python', { fg = '#908caa' })
vim.api.nvim_set_hl(0, '@boolean.python', { fg = '#908caa' })
vim.api.nvim_set_hl(0, '@constant.python', { fg = '#e0def4' })
vim.api.nvim_set_hl(0, '@variable.parameter.python', { fg = '#908caa' })

-- -- Customize Identifier for Clojure files
-- vim.api.nvim_create_autocmd("FileType", {
--     pattern = "clojure",
--     callback = function()
--         vim.cmd("highlight Identifier guifg=#c4a7e7")
--         vim.cmd("highlight Keyword guifg=#9ccfd8")
--         vim.cmd("highlight Number guifg=#e0def4")
--         vim.cmd("highlight @constant.macro guifg=#31748f")
--         vim.cmd("highlight @type guifg=#c4a7e7")
--         vim.cmd("highlight @function guifg=#ebbcba")
--         vim.cmd("highlight @function.method guifg=#9ccfd8")
--     end,
-- })

-- Set colorscheme after options
vim.cmd('colorscheme rose-pine')
