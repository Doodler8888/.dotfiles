local telescope = require('telescope')
local builtin = require('telescope.builtin')
local actions = require('telescope.actions')
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")
local previewers = require 'telescope.previewers'
local config = require('telescope.config')


require('telescope').setup({
  defaults = {
  -- find_command = { "fd", "--hidden", "--exclude=.git", "--exclude=node_modules", "--exclude=.clj-kondo" },
  file_ignore_patterns = { -- ignoring files make the search slower?
  --     "node_modules",
      -- "%.git",
      ".git/",
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
	--  mappings = {
	--      i = {
	-- ["<C-g>"] = require('telescope.actions').close
	--      },
	--      n = {
	-- ["<C-g>"] = require('telescope.actions').close
	--      },
	--    },
  },
  extensions = {
    fzf = {},
        -- ["zf-native"] = {
        --     -- options for sorting file-like items
        --     file = {
        --         -- override default telescope file sorter
        --         enable = true,
        --
        --         -- highlight matching text in results
        --         highlight_results = true,
        --
        --         -- enable zf filename match priority
        --         match_filename = true,
        --
        --         -- optional function to define a sort order when the query is empty
        --         initial_sort = nil,
        --     },
        --
        --     -- options for sorting all other items
        --     generic = {
        --         -- override default telescope generic item sorter
        --         enable = true,
        --
        --         -- highlight matching text in results
        --         highlight_results = true,
        --
        --         -- disable zf filename match priority
        --         match_filename = false,
        --
        --         -- optional function to define a sort order when the query is empty
        --         initial_sort = nil,
        --     },
        -- },
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

-- require("telescope").load_extension("zf-native")
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
            -- Remap 'n' and 'N' to move to next/previous match with error handling
            vim.keymap.set('n', 'n', function()
              local status, err = pcall(function()
                vim.cmd('normal! n')
                vim.o.hlsearch = false
              end)
              if not status then
                vim.notify("Pattern not found: " .. vim.fn.getreg('/'), vim.log.levels.WARN)
              end
            end, {silent = true})

            vim.keymap.set('n', 'N', function()
              local status, err = pcall(function()
                vim.cmd('normal! N')
                vim.o.hlsearch = false
              end)
              if not status then
                vim.notify("Pattern not found: " .. vim.fn.getreg('/'), vim.log.levels.WARN)
              end
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
vim.api.nvim_set_keymap("n", "<leader>gbs", "<cmd>lua Switch_git_branch()<CR>", {noremap = true, silent = true})


-- Function to create a new git branch starting from a selected base branch
local function create_git_branch()
  local input_opts = {
    prompt = 'Enter new branch name: ',
    default = '',
  }

  -- Prompt for new branch name
  vim.ui.input(input_opts, function(new_branch_name)
    if not new_branch_name or new_branch_name == '' then
      print('Aborting: No branch name provided.')
      return
    end

    -- Use Telescope to select the base branch
    require('telescope.builtin').git_branches({
      attach_mappings = function(prompt_bufnr, map)
        local actions = require('telescope.actions')
        local action_state = require('telescope.actions.state')

        -- Override the default <CR> action
        local function create_branch_from_selection()
          local selection = action_state.get_selected_entry()
          if not selection then
            print('Aborting: No base branch selected.')
            actions.close(prompt_bufnr)
            return
          end
          local base_branch_name = selection.value
          actions.close(prompt_bufnr)

          -- Construct the git command
          local cmd = { 'git', 'checkout', '-b', new_branch_name, base_branch_name }

          -- Execute the git command
          local result = vim.fn.systemlist(cmd)
          local ret = vim.v.shell_error

          if ret ~= 0 then
            print('Error creating branch:')
            for _, line in ipairs(result) do
              print(line)
            end
          else
            print('Branch "' .. new_branch_name .. '" created from "' .. base_branch_name .. '" and checked out.')
          end
        end

        -- Map <CR> to create the new branch
        map('i', '<CR>', create_branch_from_selection)
        map('n', '<CR>', create_branch_from_selection)
        return true
      end
    })
  end)
end

-- Create a command for easy access
vim.api.nvim_create_user_command('GitCreateBranch', create_git_branch, {})

vim.api.nvim_set_keymap('n', '<leader>gbc', ':GitCreateBranch<CR>', { noremap = true, silent = true })


local function search_shell_commands()
  -- Store the current mode
  local mode = vim.api.nvim_get_mode().mode
  local was_visual = mode:match('^[vV\22]') -- v, V, or <C-v>

  -- Get lines from the current buffer
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  -- Filter lines that start with '> ', and store their line numbers
  local cmd_lines = {}
  for idx, line in ipairs(lines) do
    if line:match('^> ') then
      table.insert(cmd_lines, 1, { line = line, lnum = idx }) -- Insert at the beginning to reverse order
    end
  end

  -- Check if any command lines are found
  if #cmd_lines == 0 then
    print('No command lines starting with "> " found in the current buffer.')
    return
  end

  -- Define the Telescope picker
  pickers.new({}, {
    prompt_title = 'Search Shell Commands',
    finder = finders.new_table {
      results = cmd_lines,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.line,
          ordinal = entry.line,
          lnum = entry.lnum,
        }
      end,
    },
    sorter = conf.generic_sorter({}),
    previewer = previewers.new_buffer_previewer({
      define_preview = function(self, entry, status)
        local lnum = entry.lnum
        local preview_height = vim.api.nvim_win_get_height(self.state.winid)
        local start_line = math.max(lnum - math.floor(preview_height / 2), 1)
        local end_line = math.min(start_line + preview_height - 1, vim.api.nvim_buf_line_count(bufnr))
        local preview_lines = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, false)
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, preview_lines)
        vim.api.nvim_buf_add_highlight(self.state.bufnr, 0, 'Visual', lnum - start_line, 0, -1)
      end,
    }),
    attach_mappings = function(prompt_bufnr, map)
      local function on_select()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          local lnum = selection.lnum
          -- Move the cursor to the selected line in the buffer
          vim.api.nvim_win_set_cursor(0, { lnum, 0 })
          -- Center the screen on the line
          vim.cmd('normal! zz')

          -- If we were in visual mode, restore it
          if was_visual then
            -- Enter visual block mode
            vim.cmd('normal! <C-v>')
          end
        else
          print('No selection made.')
        end
      end

      -- Map both normal mode and visual mode actions
      map('i', '<CR>', on_select)
      map('n', '<CR>', on_select)

      -- Add additional mappings for visual mode
      map('i', '<C-v>', function()
        on_select()
        vim.cmd('normal! <C-v>')
      end)
      map('n', '<C-v>', function()
        on_select()
        vim.cmd('normal! <C-v>')
      end)

      return true
    end,
  }):find()
end

-- Add command that works in both normal and visual mode
vim.api.nvim_create_user_command('SearchShellCommands', search_shell_commands, { range = true })


-- Set a keybinding (optional)
vim.api.nvim_set_keymap('n', '<C-s><C-o>', ':SearchShellCommands<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-s><C-o>', ':SearchShellCommands<CR>', { noremap = true, silent = true })


vim.api.nvim_set_keymap('n', '<C-s><C-h>', ':Telescope command_history<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-x>', ':Telescope commands<CR>', { noremap = true, silent = true })


-- Define the custom action
local function insert_selection_into_cmdline(prompt_bufnr)
  -- Get the selected entry
  local entry = action_state.get_selected_entry()
  local cmd = entry.value

  -- Close the Telescope window
  actions.close(prompt_bufnr)

  -- Insert the selected item into the command line
  -- This simulates typing ':' followed by the selected item
  vim.api.nvim_feedkeys(':' .. cmd, 'n', true)
end

-- vim.api.nvim_create_user_command('InsertSelectionIntoCmdline', insert_selection_into_cmdline, {})

-- -- Telescope setup with custom mappings
-- vim.api.nvim_set_keymap('n', '<M-CR>', ':InsertSelectionIntoCmdline<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('i', '<M-CR>', ':InsertSelectionIntoCmdline<CR>', { noremap = true, silent = true })

require('telescope').setup{
  defaults = {
    mappings = vim.tbl_deep_extend('force', config.values.mappings, {
      i = {
        -- Your custom mappings in insert mode
        -- ["<C-[>"] = insert_selection_into_cmdline,
        ["<M-CR>"] = insert_selection_into_cmdline,
        ["<C-g>"] = actions.close,
      },
      n = {
        -- Your custom mappings in normal mode
        -- ["<C-[>"] = insert_selection_into_cmdline,
        ["<M-CR>"] = insert_selection_into_cmdline,
        ["<C-g>"] = actions.close,
      },
    }),
  },
}
