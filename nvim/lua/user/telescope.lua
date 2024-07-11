-- Useful for easily creating commands
local z_utils = require("telescope._extensions.zoxide.utils")
local actions = require('telescope.actions')

require('telescope').setup({
  defaults = {
  -- find_command = { "fd", "--hidden", "--exclude=.git", "--exclude=node_modules", "--exclude=.clj-kondo" },
  -- file_ignore_patterns = { -- ignoring files make the search slower?
  --     "node_modules",
  --     "%.git",
  --     "target",
  --     "build",
  --     ".go",
  --     ".clojure",
  --     ".vagrant",
  --     -- ".raku",
  --     "perl5",
  --     ".local",
  --     ".qlot",
  --     ".m2",
  --     "common-lisp",
  --     "snap",
  --     ".venv",
  --     ".lsp",
  --     "%.clj-kondo/",
  --     ".cpcache",
  --   },
    mappings = {
      i = {
	["<C-g>"] = require('telescope.actions').close
      },
      n = {
	["<C-g>"] = require('telescope.actions').close
      },
    },
  },
  extensions = {
        ["zf-native"] = {
            -- options for sorting file-like items
            file = {
                -- override default telescope file sorter
                enable = true,

                -- highlight matching text in results
                highlight_results = true,

                -- enable zf filename match priority
                match_filename = true,

                -- optional function to define a sort order when the query is empty
                initial_sort = nil,
            },

            -- options for sorting all other items
            generic = {
                -- override default telescope generic item sorter
                enable = true,

                -- highlight matching text in results
                highlight_results = true,

                -- disable zf filename match priority
                match_filename = false,

                -- optional function to define a sort order when the query is empty
                initial_sort = nil,
            },
        },
    -- fzf = {
    --   fuzzy = true, -- false will only do exact matching
    --   override_generic_sorter = true, -- override the generic sorter
    --   override_file_sorter = true, -- override the file sorter
    --   case_mode = "smart_case", -- or "ignore_case" or "respect_case"
    --   -- the default case_mode is "smart_case"
    -- },
    -- persisted = {
    --   layout_config = { width = 0.55, height = 0.55 },
    -- },
    zoxide = {
      prompt_title = "[ Walking on the shoulders of TJ ]",
      mappings = {
	default = {
	  after_action = function(selection)
	    print("Update to (" .. selection.z_score .. ") " .. selection.path)
	  end
	},
	["<leader>fz"] = {
	  before_action = function(selection) print("before C-s") end,
	  action = function(selection)
	    vim.cmd.edit(selection.path)
	  end
	},
      },
    }
  },
})

-- vim.api.nvim_set_keymap('n', '<leader>nf', ':lua require("telescope.builtin").find_files({ prompt_title = "Search Notes", cwd = "~/.secret_dotfiles/notes", hidden = true })<CR>', {noremap = true, silent = true})


require("telescope").load_extension("zf-native")
-- require("telescope").load_extension("fzf")
-- require("telescope").load_extension("ui-select")
-- -- require("telescope").load_extension("persisted")
require('telescope').load_extension('zoxide')
--
vim.api.nvim_set_keymap(
	"n",
	"<leader>ff",
	[[<cmd>lua require('telescope.builtin').find_files({ hidden = true, sort = true })<CR>]],
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>fr",
	[[<Cmd>lua require('telescope.builtin').find_files({ hidden = true, sort = true, cwd = '/' })<CR>]],
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>fh",
	[[<Cmd>lua require('telescope.builtin').find_files({ hidden = true, sort = true, cwd = '~/' })<CR>]],
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    "<leader>fs",
    [[<cmd>lua require('telescope.builtin').live_grep()<CR>]],
    { noremap = true, silent = true }
)

local action_state = require('telescope.actions.state')

_G.telescope_current_buffer_fuzzy_find = function()
  require('telescope.builtin').current_buffer_fuzzy_find({
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        if selection then
          -- Get the current input from the Telescope prompt
          local current_picker = action_state.get_current_picker(prompt_bufnr)
          local prompt = current_picker:_get_prompt()

          -- Close the Telescope prompt
          actions.close(prompt_bufnr)

          -- Move the cursor to the selected line
          vim.api.nvim_win_set_cursor(0, {selection.lnum, 0})

          -- Set the search register with the prompt input
          vim.fn.setreg('/', vim.fn.escape(prompt, '\\/'))

          -- Disable highlighting
          vim.o.hlsearch = false

          -- Schedule a function to re-enable 'n' and 'N' functionality
          vim.schedule(function()
            -- Create a custom command to toggle search highlighting
            vim.api.nvim_create_user_command('ToggleSearchHL', function()
              vim.o.hlsearch = not vim.o.hlsearch
            end, {})

            -- Remap 'n' and 'N' to move to next/previous match without highlighting
            vim.keymap.set('n', 'n', function()
              vim.cmd('normal! n')
              vim.o.hlsearch = false
            end, {silent = true})

            vim.keymap.set('n', 'N', function()
              vim.cmd('normal! N')
              vim.o.hlsearch = false
            end, {silent = true})
          end)
        end
      end)
      return true
    end
  })
end

vim.api.nvim_set_keymap('n', '<C-s><C-s>', '<cmd>lua telescope_current_buffer_fuzzy_find()<CR>', { noremap = true, silent = true })

function _G.rg_current_file()
  local filename = vim.api.nvim_buf_get_name(0)
  require('telescope.builtin').grep_string({
    prompt_title = "Ripgrep Current File",
    search = "",  -- This can be left empty; user will input the search term interactively
    search_dirs = { filename },
    use_less = false,
    attach_mappings = function(_, map)
      map("i", "<CR>", require('telescope.actions').select_default)
      return true
    end,
    entry_maker = function(entry)
      local filename_end = entry:find(":")
      local line_end = entry:find(":", filename_end + 1)
      local lnum = tonumber(entry:sub(filename_end + 1, line_end - 1))
      local display_text = entry:sub(line_end + 1)
      return {
        value = entry,
        ordinal = display_text,
        display = display_text,
        filename = filename,
        lnum = lnum,
        text = display_text,
      }
    end,
    sorter = require('telescope.config').values.generic_sorter({}),
    previewer = require('telescope.previewers').vim_buffer_vimgrep.new({
      get_bufnr = function(_, entry)
        return vim.fn.bufnr(entry.filename)
      end,
    }),
  })
end

-- Works on all files in a catalog from where neovim was opened
function _G.rg_neovim_session()
  local filename = vim.api.nvim_buf_get_name(0)
  require('telescope.builtin').live_grep({
    prompt_title = "Ripgrep Current File",
    search = "",
    cwd = vim.fn.fnamemodify(filename, ':p:h'),
    hidden = true,
    use_less = false,
    grep_open_files = false,
    attach_mappings = function(_, map)
      map("i", "<CR>", actions.select_default)
      return true
    end,
    extra_search_params = {"--file", filename},
  })
end

vim.api.nvim_set_keymap('n', '<leader>rf', ":lua rg_neovim_session()<CR>", {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<leader>rc', ":lua rg_current_file()<CR>", {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<C-s><C-s>', ":lua rg_current_file()<CR>", {noremap = true, silent = true})

function Search_and_insert_from_home()
    -- Load the built-in Telescope function and configuration library
    local builtin = require('telescope.builtin')
    -- local actions = require('telescope.actions') -- I commented this line out because i already have this viriable defined at the start of the file.
    local action_state = require('telescope.actions.state')

    -- Configure the file search
    builtin.find_files({
        prompt_title = "Search Files from Home",
        cwd = vim.fn.expand("~"),  -- Set the working directory to the user's home
        find_command = {'find', vim.fn.expand("~"), '-type', 'f'},  -- Use find to get absolute paths

        -- Attach custom functionality when an item is selected
        attach_mappings = function(prompt_bufnr, map)
            -- Define what happens when an item is selected
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)  -- Close the Telescope window
                local selection = action_state.get_selected_entry()  -- Get the selected file
                if selection then
                    -- Insert the selected file path at the current cursor position
                    local cursor_pos = vim.api.nvim_win_get_cursor(0)
                    local line = vim.api.nvim_get_current_line()
                    local before_cursor = line:sub(1, cursor_pos[2])
                    local after_cursor = line:sub(cursor_pos[2] + 1)
                    local new_line = before_cursor .. selection.value .. after_cursor
                    vim.api.nvim_set_current_line(new_line)
                    -- Move cursor to the end of the inserted text
                    vim.api.nvim_win_set_cursor(0, {cursor_pos[1], cursor_pos[2] + #selection.value})
                end
            end)
            return true
        end
    })
end

-- Set a keymap to trigger the function (adjust the keymap as needed)
vim.api.nvim_set_keymap('n', '<leader>ih', '<cmd>lua Search_and_insert_from_home()<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<C-f><C-i>h', '<cmd>lua Search_and_insert_from_home()<CR>', {noremap = true, silent = true})

-- vim.api.nvim_set_keymap('n', '<leader>fp', [[<cmd>Telescope persisted<CR>]], { noremap = true, silent = true })

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
--  vim.keymap.set("n", "<Leader>tdh", _G.telescope_home_dirs)
--
--  function Find_files_and_change_dir()
--  	require("telescope.builtin").find_files({
--  		hidden = true,
--  		sort = true,
--  		cwd = "~/",
--  		attach_mappings = function(prompt_bufnr, map)
--  			local action_state = require("telescope.actions.state")
--  			local actions = require("telescope.actions")
--
--  			-- Define the action to open the file and change the directory
--  			local open_file_and_change_dir = function()
--  				local selection = action_state.get_selected_entry()
--  				actions.close(prompt_bufnr) -- Close Telescope prompt before opening the file
--  				local dir = vim.fn.fnamemodify(selection.path, ":p:h")
--  				vim.cmd("lcd " .. vim.fn.fnameescape(dir))
--  				vim.cmd("e " .. vim.fn.fnameescape(selection.path)) -- Open the file
--  			end
--
--  			-- Map the custom action to `<CR>` (Enter key)
--  			map("i", "<CR>", open_file_and_change_dir)
--  			map("n", "<CR>", open_file_and_change_dir)
--
--  			-- Return true to keep the rest of the mappings
--  			return true
--  		end,
--  	})
--  end
--
--  -- Bind the new function to a keymapping
--  vim.api.nvim_set_keymap(
--  	"n",
--  	"<leader>fh",
--  	"<Cmd>lua Find_files_and_change_dir()<CR>",
--  	{ noremap = true, silent = true }
--  )




-- Function to search within the notes directory
