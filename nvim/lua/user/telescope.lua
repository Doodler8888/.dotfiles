local builtin = require('telescope.builtin')
local actions = require('telescope.actions')
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")


require('telescope').setup({
  defaults = {
  -- find_command = { "fd", "--hidden", "--exclude=.git", "--exclude=node_modules", "--exclude=.clj-kondo" },
  file_ignore_patterns = { -- ignoring files make the search slower?
  --     "node_modules",
      "%.git",
      -- ".git/",
      "%.terraform",
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
      ".venv",
      "ansible_env_310",
  --     ".lsp",
  --     "%.clj-kondo/",
  --     ".cpcache",
    },
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

-- -- Helper function to get git root
-- local function get_git_root()
--     local git_cmd = io.popen("git rev-parse --show-toplevel 2> /dev/null")
--     if git_cmd == nil then return nil end
--     local git_root = git_cmd:read("*l")
--     git_cmd:close()
--     return git_root
-- end
--
-- -- Custom picker for project files
-- local function project_files()
--     local git_root = get_git_root()
--     builtin.find_files({
--         cwd = git_root or vim.loop.cwd(),
--         hidden = true,
--         no_ignore = true,
--         -- find_command = { "fd", "--type", "f", "--strip-cwd-prefix" }
--     })
-- end

-- -- Create a command to run the project_files picker
-- vim.api.nvim_create_user_command('ProjectFiles', project_files, {})

-- Optional: Add a keymap
-- vim.api.nvim_set_keymap('n', '<leader>ff', ':ProjectFiles<CR>', { noremap = true, silent = true })

require("telescope").load_extension("zf-native")
-- require("telescope").load_extension("fzf")
-- require("telescope").load_extension("ui-select")
-- -- require("telescope").load_extension("persisted")
require('telescope').load_extension('zoxide')

vim.api.nvim_set_keymap(
    "n",
    "<leader>ff",
    [[<cmd>lua require('telescope.builtin').find_files({ hidden = true, no_ignore = true, sort = true })<CR>]],
    { noremap = true, silent = true }
)

-- vim.api.nvim_set_keymap(
-- 	"n",
-- 	"<leader>fr",
-- 	[[<Cmd>lua require('telescope.builtin').find_files({ hidden = true, sort = true, cwd = '/' })<CR>]],
-- 	{ noremap = true, silent = true }
-- )
-- vim.api.nvim_set_keymap(
-- 	"n",
-- 	"<leader>fh",
-- 	[[<Cmd>lua require('telescope.builtin').find_files({ hidden = true, sort = true, cwd = '~/' })<CR>]],
-- 	{ noremap = true, silent = true }
-- )
vim.api.nvim_set_keymap(
    "n",
    "<leader>fs",
    [[<cmd>lua require('telescope.builtin').live_grep()<CR>]],
    { noremap = true, silent = true }
)

_G.telescope_current_buffer_fuzzy_find = function()
  -- Check if we're in the command-line window
  if vim.fn.getcmdwintype() ~= '' then
    print("Telescope cannot be opened from the command-line window.")
    return
  end
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

          -- Schedule a function to re-enable 'n' and 'N' functionality
          vim.schedule(function()

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

-- vim.api.nvim_set_keymap('n', '<leader>rf', ":lua rg_neovim_session()<CR>", {noremap = true, silent = true})
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

local function zoxide_list()
  local handle = io.popen("zoxide query -l")
  local result = handle:read("*a")
  handle:close()

  local dirs = {}
  for dir in result:gmatch("[^\r\n]+") do
    table.insert(dirs, dir)
  end
  return dirs
end

local function zoxide_telescope()
  local dirs = zoxide_list()

  pickers.new({
    layout_strategy = "horizontal",
    layout_config = {
      width = 0.5,
      height = 0.5,
      prompt_position = "bottom"
    },
  }, {
    prompt_title = "Zoxide Directories",
    finder = finders.new_table {
      results = dirs
    },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        vim.cmd("lcd " .. selection[1])
	vim.cmd("Oil " .. selection[1])
        print("Navigated to: " .. selection[1])
      end)
      return true
    end,
  }):find()
end

vim.api.nvim_create_user_command("Zoxide", zoxide_telescope, {})

vim.api.nvim_set_keymap('n', 'gz', ':Zoxide<CR>', { noremap = true, silent = true })


function Switch_git_branch()
  local function get_git_branches()
    local handle = io.popen("git branch --format='%(refname:short)'")
    local result = handle:read("*a")
    handle:close()
    local branches = {}
    for branch in result:gmatch("[^\r\n]+") do
      table.insert(branches, branch)
    end
    return branches
  end

  local function switch_branch(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    actions.close(prompt_bufnr)
    if selection then
      vim.fn.system("git checkout " .. selection[1])
      print("Switched to branch: " .. selection[1])
      vim.cmd("e!") -- Refresh the current buffer
    end
  end

  pickers.new({
    layout_strategy = "horizontal",
    layout_config = {
      width = 0.5,
      height = 0.5,
      prompt_position = "bottom"
    },
  }, {
    prompt_title = "Git Branches",
    finder = finders.new_table {
      results = get_git_branches()
    },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(_, map)
      map("i", "<CR>", switch_branch)
      map("n", "<CR>", switch_branch)
      return true
    end,
  }):find()
end

-- Add this line to make the function globally accessible
vim.api.nvim_set_keymap("n", "<leader>gb", "<cmd>lua Switch_git_branch()<CR>", {noremap = true, silent = true})
