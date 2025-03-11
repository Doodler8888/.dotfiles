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
		CursorLine = { bg = 'none' },
		-- CursorLineLn = { bg = 'foam', blend = 10, bold = false },
		StatusLine = { fg = 'love', bg = 'love', blend = 10, bold = false },
		StatusLineNC = { link = "StatusLine", bold = false },
		-- FloatBorder = { fg = 'highlight_med', bg = 'none', bold = false },
		TabLine = { bg = 'none', bold = false },
		TabLineFill = { bg = 'none', bold = false },
		TabLineSel = { bg = 'muted', blend = 25, bold = false },
		Title = { bold = false }, -- responsible for the split counter
		MatchParen = { bg = 'muted', fg = 'muted' },
		-- Search = { link = "Visual" },
		-- IncSearch = { fg = "subtle" },
		Substitute = { link = "Visual" },
		CurSearch = { bg = 'subtle' },
		-- TermCursor = { link = "Visual" },
		Directory = { fg = 'foam', bold = false },
		NotificationInfo = { bg = 'none', fg = '#e0def4' },
		NotificationError = { bg = 'none', fg = '#e0def4' },
		NotificationWarning = { bg = 'none', fg = '#e0def4' },
		TelescopeNormal = { fg = '#e0def4', bg = 'none' },
		TelescopeSelection = { fg = 'none', bg = 'subtle', blend = 18 },
		TelescopeMatching = { fg = 'none', bg = 'subtle', blend = 60 },
		-- TroubleNormal = { fg = 'none', bg = 'none' },
		-- TroubleCount = { fg = 'iris', bg = 'none' },
		-- TroubleIndent = { fg = '#1d1f21', bg = 'none' },
		-- QuickFixLine = { fg = '#e0def4', bg = 'subtle', blend = 18 },
		QuickFixLine = { fg = 'none', bg = 'subtle', blend = 18 },
		MiniFilesCursorLine = { fg = 'none', bg = '#1d1f21' },
		-- MiniFilesCursorLine = { fg = 'none', bg = '#1d1f21', blend = 18 },

		['@neorg.markup.italic.norg'] = { italic = true },
		['@neorg.markup.bold.norg'] = { bold = true },

		['@markup.italic.markdown_inline'] = { fg = '#b2aec2', italic = true },
		['@markup.raw.markdown_inline'] = { bg = '#17191a', fg = '#b2aec2' },
		['@markup.strong.markdown_inline'] = { fg = 'muted', bold = true },
		['@markup.raw.block.markdown'] = { fg = '#e0def4' },
		['@label.markdown'] = { fg = 'subtle' },
		['@markup.raw.block.markdown'] = { fg = 'subtle' },
		['@markup.heading.1.markdown'] = { fg = 'rose' },
		['@markup.heading.2.markdown'] = { fg = 'foam' },
		['@markup.heading.3.markdown'] = { fg = 'iris' },
		['@markup.heading.4.markdown'] = { fg = 'muted' },
		['@markup.heading.5.markdown'] = { fg = 'pine' },



		-- I probably don't need all of them. They were added because of url's in comment string had their own color.
		-- Also, if i try to change the highlighting like i did wit python below, then it will work very slow for some reason.
		['@comment.lua'] = { fg = 'muted' },
		['@spell.lua'] = { fg = 'muted' },
		['@string.special.url.comment'] = { fg = 'muted' },
		['@nospell.comment'] = { fg = 'muted' },
		['@lsp.type.comment.lua'] = { fg = 'muted' },

		['@function.method.call.go'] = { fg = 'rose' },
		-- ['@constant.go'] = { fg = '#e0def4' },
		['@variable.parameter.go'] = { fg = '#e0def4' },
		['@type.go'] = { fg = 'iris' },
		['@type.builtin.go'] = { fg = 'iris' },
		['@number.go'] = { fg = '#908caa' },
		['@function.builtin.go'] = { fg = 'love' },
		['@constant.go'] = { fg = 'foam' },

		-- It works on posix shell too (the face is for shebang)
		['@keyword.directive.bash'] = { fg = 'muted' },
		['@number.bash'] = { fg = '#908caa' },
		['@constant.bash'] = { fg = 'foam' },

		['zshNumber'] = { fg = '#908caa' },

		['@number.python'] = { fg = '#908caa' },
		['@boolean.python'] = { fg = '#908caa' },
		['@constant.python'] = { fg = '#e0def4' },
		['@variable.parameter.python'] = { fg = '#908caa' },
		['@keyword.directive.python'] = { fg = 'muted' },
		['@string.escape.python'] = { fg = 'gold' },
		['@string.regexp.python'] = { fg = 'gold' },
		['@function.builtin.python'] = { fg = 'love' },
		['@function.method.call.python'] = { fg = 'rose' },
		['@keyword.operator.python'] = { fg = 'pine' },
		['@constant.builtin.python'] = { fg = 'foam' },

		['@number.perl'] = { fg = '#908caa' },
		['@string.escape.perl'] = { fg = 'gold' },
		['@string.escape.perl'] = { fg = 'gold' },
		['@variable.builtin.perl'] = { fg = '#e0def4' },
		['@string.regexp.perl'] = { fg = 'gold' },
	      }
	    })


-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#17191a" })

-- vim.api.nvim_set_hl(0, '@string.special.symbol.clojure', { link = 'Identifier' })
-- vim.api.nvim_set_hl(0, '@lsp.type.macro.clojure', { link = '@constant.macro' })
-- vim.api.nvim_set_hl(0, '@type.clojure', { link = '@type' })
-- vim.api.nvim_set_hl(0, '@function.call.clojure', { link = '@function' })
-- vim.api.nvim_set_hl(0, '@function.method.clojure', { link = '@function.method' })

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
