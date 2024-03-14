require('telescope').setup({
	defaults = {
		find_command = { "fd", "--type=f", "--hidden", "--exclude=.git", "--exclude=node_modules" },
	},
	extensions = {
		-- ["ui-select"] = {
		-- 	require("telescope.themes").get_dropdown {
		-- 		-- even more opts
		-- 	}
		--
		-- 	-- pseudo code / specification for writing custom displays, like the one
		-- 	-- for "codeactions"
		-- 	-- specific_opts = {
		-- 		--   [kind] = {
		-- 			--     make_indexed = function(items) -> indexed_items, width,
		-- 				--     make_displayer = function(widths) -> displayer
		-- 					--     make_display = function(displayer) -> function(e)
		-- 						--     make_ordinal = function(e) -> string
		-- 							--   },
		-- 							--   -- for example to disable the custom builtin "codeactions" display
		-- 							--      do the following
		-- 							--   codeactions = false,
		-- 							-- }
		-- 						},
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			-- the default case_mode is "smart_case"
		},
		persisted = {
			layout_config = { width = 0.55, height = 0.55 },
		},
		zoxide = {},
	},
})

-- vim.api.nvim_set_keymap('n', '<leader>nf', ':lua require("telescope.builtin").find_files({ prompt_title = "Search Notes", cwd = "~/.secret_dotfiles/notes", hidden = true })<CR>', {noremap = true, silent = true})



-- require("telescope").load_extension("fzf")
-- require("telescope").load_extension("ui-select")
-- -- require("telescope").load_extension("persisted")
-- -- require('telescope').load_extension('zoxide')
--
-- -- vim.api.nvim_set_keymap(
-- -- 	"n",
-- -- 	"<leader>ff",
-- -- 	[[<cmd>lua require('telescope.builtin').find_files({ hidden = true, sort = true })<CR>]],
-- -- 	{ noremap = true, silent = true }
-- -- )
-- -- -- vim.api.nvim_set_keymap(
-- -- -- 	"n",
-- -- -- 	"<leader>th",
-- -- -- 	[[<Cmd>lua require('telescope.builtin').find_files({ hidden = true, sort = true, cwd = '~/' })<CR>]],
-- -- -- 	{ noremap = true, silent = true }
-- -- -- )
-- -- vim.api.nvim_set_keymap(
-- -- 	"n",
-- -- 	"<leader>fs",
-- -- 	[[<cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep > ") })<CR>]],
-- -- 	{ noremap = true, silent = true }
-- -- )
-- -- -- vim.api.nvim_set_keymap('n', '<leader>fp', [[<cmd>Telescope persisted<CR>]], { noremap = true, silent = true })
--
-- _G.telescope_home_dirs = function(opts)
-- 	opts = opts or {}
-- 	local action_state = require("telescope.actions.state")
-- 	local actions = require("telescope.actions")
-- 	local home = vim.fn.expand("~") -- Expand the home directory
--
-- 	require("telescope.builtin").find_files({
-- 		prompt_title = "Home Directories",
-- 		cwd = home, -- Use the expanded home directory
-- 		find_command = { "fd", "--type", "d", ".", "--hidden", "--exclude", ".git", home },
-- 		attach_mappings = function(prompt_bufnr)
-- 			actions.select_default:replace(function()
-- 				actions.close(prompt_bufnr) -- Close the Telescope picker
-- 				local selection = action_state.get_selected_entry() -- Get the selected directory
-- 				local path = vim.fn.fnamemodify(selection[1], ":p") -- Get the full path
-- 				-- Change the directory for the current window
-- 				vim.cmd("lcd " .. vim.fn.fnameescape(path))
-- 				-- Open the oil buffer for the chosen directory
-- 				vim.cmd("Oil " .. vim.fn.fnameescape(path))
-- 			end)
-- 			return true
-- 		end,
-- 	})
-- end
--
-- -- You can then map this function to a command or keybinding
-- vim.cmd([[command! TelescopeHomeDirs lua _G.telescope_home_dirs()]])
-- -- vim.keymap.set("n", "<Leader>tdh", _G.telescope_home_dirs)
--
-- -- function Find_files_and_change_dir()
-- -- 	require("telescope.builtin").find_files({
-- -- 		hidden = true,
-- -- 		sort = true,
-- -- 		cwd = "~/",
-- -- 		attach_mappings = function(prompt_bufnr, map)
-- -- 			local action_state = require("telescope.actions.state")
-- -- 			local actions = require("telescope.actions")
-- --
-- -- 			-- Define the action to open the file and change the directory
-- -- 			local open_file_and_change_dir = function()
-- -- 				local selection = action_state.get_selected_entry()
-- -- 				actions.close(prompt_bufnr) -- Close Telescope prompt before opening the file
-- -- 				local dir = vim.fn.fnamemodify(selection.path, ":p:h")
-- -- 				vim.cmd("lcd " .. vim.fn.fnameescape(dir))
-- -- 				vim.cmd("e " .. vim.fn.fnameescape(selection.path)) -- Open the file
-- -- 			end
-- --
-- -- 			-- Map the custom action to `<CR>` (Enter key)
-- -- 			map("i", "<CR>", open_file_and_change_dir)
-- -- 			map("n", "<CR>", open_file_and_change_dir)
-- --
-- -- 			-- Return true to keep the rest of the mappings
-- -- 			return true
-- -- 		end,
-- -- 	})
-- -- end
--
-- -- -- Bind the new function to a keymapping
-- -- vim.api.nvim_set_keymap(
-- -- 	"n",
-- -- 	"<leader>fh",
-- -- 	"<Cmd>lua Find_files_and_change_dir()<CR>",
-- -- 	{ noremap = true, silent = true }
-- -- )




-- Function to search within the notes directory

