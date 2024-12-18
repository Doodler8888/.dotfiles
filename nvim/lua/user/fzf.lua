require("fzf-lua").setup({
	"telescope",
	files = {
		cmd = "fd --type f --type d --hidden --follow --exclude .git --exclude .snapshots --exclude var --exclude opt --exclude lib --exclude lib64 --exclude mnt --exclude proc --exclude run --exclude sbin --exclude srv --exclude sys --exclude tmp",
	},
	winopts = {
		height = 0.55,
		width = 0.50,
		border = "rounded", -- or 'double', 'rounded', 'sharp', etc.
		-- other window options
		preview = {
			hidden = "hidden", -- Disable the preview window
		},
	},
})

-- vim.api.nvim_set_keymap("n", "<leader>ff", ":lua vim.cmd('FzfLua files')<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>fh", ":FzfLua files cwd=~/<CR>", { noremap = true })
-- vim.api.nvim_set_keymap("n", "<leader>fr", ":FzfLua files cwd=/<CR>", { noremap = true })
-- vim.api.nvim_set_keymap("n", "<leader>fs", ":FzfLua grep_project<CR>", { noremap = true })
-- vim.api.nvim_set_keymap("n", "<C-s><C-s>", ":FzfLua lgrep_curbuf<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>fb", ":FzfLua buffers<CR>", { noremap = true })

-- vim.keymap.set({ "i" }, "<C-y>", function()
-- 	require("fzf-lua").complete_path({
-- 		cmd = "fd --hidden . / --follow --exclude .git --exclude .snapshots --exclude opt --exclude lib --exclude lib64 --exclude mnt --exclude proc --exclude run --exclude sbin --exclude srv --exclude sys --exclude tmp",
-- 	})
-- end, { silent = true, desc = "Fuzzy complete path" })

vim.keymap.set({ "i" }, "<C-f><C-i>c", function()
	-- Get the current line and cursor position
	local line = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2]

	-- Get the path fragment to the left of the cursor
	local path_fragment = line:sub(1, col):match("([^%s]+)$")

	-- If there's no path fragment found, default to searching from the current directory
	if not path_fragment or path_fragment == "" then
		path_fragment = "."
	end

	-- Run the fd command with the dynamic path fragment
	require("fzf-lua").complete_path({
		cmd = string.format("fd --hidden", vim.fn.shellescape(path_fragment)),
	})
end, { silent = true, desc = "Fuzzy complete path" })



-- vim.keymap.set({ "n" }, "<leader>ih", function()
-- vim.keymap.set({ "i" }, "<C-f><C-i>h", function()
--     -- Get the current line and cursor position
--     local line = vim.api.nvim_get_current_line()
--     local col = vim.api.nvim_win_get_cursor(0)[2]
--
--     -- Get the path fragment to the left of the cursor
--     -- Ensure only the part of the line up to the cursor is considered
--     local path_fragment = line:sub(1, col):match("([^%s]+)$")
--
--     -- If there's no path fragment found, default to searching from the home directory
--     if not path_fragment or path_fragment == "" then
--         path_fragment = "."  -- Search from the base directory without a specific pattern
--     else
--         -- Ensure the path fragment does not extend beyond the cursor position
--         path_fragment = line:sub(1, col):match("([^%s]+)$")
--     end
--
--     -- Run the fd command with the dynamic path fragment from the home directory
--     require("fzf-lua").complete_path({
--         cmd = string.format("fd --hidden --base-directory %s %s", vim.fn.shellescape(vim.fn.expand("~")), vim.fn.shellescape(path_fragment)),
--     })
-- end, { silent = true, desc = "Fuzzy complete path from home" })


vim.keymap.set({ "i" }, "<C-f><C-i>r", function()
    -- Get the current line and cursor position
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2]

    -- Get the path fragment to the left of the cursor
    local path_fragment = line:sub(1, col):match("([^%s]+)$")

    -- If there's no path fragment found, default to searching from the root directory
    if not path_fragment or path_fragment == "" then
        path_fragment = "."  -- Search from the base directory without a specific pattern
    end

    -- Run the fd command with the dynamic path fragment from the root directory
    require("fzf-lua").complete_path({
        cmd = string.format("fd --hidden --base-directory / %s", vim.fn.shellescape(path_fragment)),
    })
end, { silent = true, desc = "Fuzzy complete path from root" })


-- vim.g.fzf_colors = {
--   ["fg"] = {"fg", "Normal"},
--   ["bg"] = {"bg", "Normal"},
--   ["hl"] = {"fg", "Comment"},
--   ["fg+"] = {"fg", "CursorLine", "CursorColumn", "Normal"},
--   ["bg+"] = {"bg", "CursorLine", "CursorColumn"},
--   ["hl+"] = {"fg", "Statement"},
--   ["info"] = {"fg", "PreProc"},
--   ["border"] = {"fg", "Ignore"},
--   ["prompt"] = {"fg", "Conditional"},
--   ["pointer"] = {"fg", "Exception"},
--   ["marker"] = {"fg", "Keyword"},
--   ["spinner"] = {"fg", "Label"},
--   ["header"] = {"fg", "Comment"}
-- }

_G.fzf_home_dirs = function(opts)
	local fzf_lua = require("fzf-lua")
	opts = opts or {}
	opts.prompt = "Home Directories> "
	opts.fn_transform = function(x)
		return fzf_lua.utils.ansi_codes.magenta(x)
	end
	opts.actions = {
		["default"] = function(selected)
			vim.cmd("lcd " .. selected[1])
			vim.cmd("Oil " .. selected[1])
		end,
	}
	-- Add a dot before the path to search for all directories within the home directory
	fzf_lua.fzf_exec("fd --type d . --hidden --exclude .git ~", opts)
end

_G.fzf_root_dirs = function(opts)
	local fzf_lua = require("fzf-lua")
	opts = opts or {}
	opts.prompt = "Root Directories> "
	opts.fn_transform = function(x)
		return fzf_lua.utils.ansi_codes.magenta(x)
	end
	opts.actions = {
		["default"] = function(selected)
			vim.cmd("cd " .. selected[1])
			vim.cmd("Oil " .. selected[1])
		end,
	}
	-- Add a dot before the path to search for all directories within the root directory
	fzf_lua.fzf_exec("fd --type d --hidden --exclude .git . /", opts)
end

_G.fzf_current_dirs = function(opts)
	local fzf_lua = require("fzf-lua")
	opts = opts or {}
	opts.prompt = "Current Directories> "
	opts.actions = {
		["default"] = function(selected)
			vim.cmd("Oil " .. selected[1])
		end,
	}
	fzf_lua.fzf_exec("fd --type d --hidden --exclude .git", opts)
end

-- Map our providers to user commands
vim.cmd([[command! -nargs=* HomeDirs lua _G.fzf_home_dirs()]])
vim.cmd([[command! -nargs=* RootDirs lua _G.fzf_root_dirs()]])
vim.cmd([[command! -nargs=* CurrentDirs lua _G.fzf_current_dirs()]])

-- Map our providers to keybinds
vim.keymap.set("n", "<Leader>dh", _G.fzf_home_dirs)
vim.keymap.set("n", "<Leader>dr", _G.fzf_root_dirs)
vim.keymap.set("n", "<Leader>df", _G.fzf_current_dirs)
vim.keymap.set("n", "<Leader>fd", _G.fzf_current_dirs)





