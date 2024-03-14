vim.o.packpath = "/tmp/nvim/site"

local plugins = {
  rose_pine = "https://github.com/rose-pine/neovim",
  -- ADD OTHER PLUGINS _NECESSARY_ TO REPRODUCE THE ISSUE
}

for name, url in pairs(plugins) do
  local install_path = "/tmp/nvim/site/pack/test/start/" .. name
  if vim.fn.isdirectory(install_path) == 0 then
    vim.fn.system({ "git", "clone", "--depth=1", url, install_path })
  end
end

require('rose-pine').setup({
	-- --- @usage 'auto'|'main'|'moon'|'dawn'
	variant = 'main',
	--- @usage 'main'|'moon'|'dawn'
	dark_variant = 'main',
	-- bold_vert_split = false,
	-- dim_nc_background = false,

	styles = {
	  transparency = true,
	  itlatic = false,
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
		ColorColumn = { bg = 'subtle', blend = 35 },
		CursorLine = { bg = 'foam', blend = 10 },
		CursorLineLn = { bg = 'foam', blend = 10 },
		StatusLine = { fg = 'love', bg = 'love', blend = 10 },
		StatusLineNC = { link = "StatusLine" },
		-- FloatBorder = { fg = 'iris', bg = 'none' },
		FloatBorder = { fg = 'highlight_med', bg = 'none' },
		TabLine = { bg = 'none' },
		TabLineFill = { bg = 'none' },
		TabLineSel = { --[[ fg = 'love', ]] bg = 'muted', blend = 25 }
}
})

-- Set colorscheme after options
vim.cmd('colorscheme rose-pine')
