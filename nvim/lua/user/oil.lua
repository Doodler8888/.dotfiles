require("oil").setup({
  -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
  -- Set to false if you still want to use netrw.
  default_file_explorer = true,
  -- Id is automatically added at the beginning, and name at the end
  -- See :help oil-columns
  columns = {
    "icon",
    "permissions",
    "size",
    "mtime",
  },
  -- Buffer-local options to use for oil buffers
  buf_options = {
    buflisted = false,
    bufhidden = "hide",
  },
  -- Window-local options to use for oil buffers
  win_options = {
    wrap = false,
    signcolumn = "no",
    cursorcolumn = false,
    foldcolumn = "0",
    spell = false,
    list = false,
    conceallevel = 3,
    concealcursor = "nvic",
  },
  -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
  delete_to_trash = true,
  -- Skip the confirmation popup for simple operations
  skip_confirm_for_simple_edits = true,
  -- Change this to customize the command used when deleting to trash
  -- trash_command = "trash",
  -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
  prompt_save_on_select_new_entry = false,
  -- Oil will automatically delete hidden buffers after this delay
  -- You can set the delay to false to disable cleanup entirely
  -- Note that the cleanup process only starts when none of the oil buffers are currently displayed
  cleanup_delay_ms = 2000,
  -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
  -- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
  -- Additionally, if it is a string that matches "actions.<name>",
  -- it will use the mapping at require("oil.actions").<name>
  -- Set to `false` to remove a keymap
  -- See :help oil-actions for a list of all available actions
  keymaps = {
    ["g?"] = "actions.show_help",
    ["<CR>"] = "actions.select",
    -- ["<C-s>"] = "actions.select_vsplit",
    -- ["<C-h>"] = "actions.select_split",
    -- ["<C-t>"] = "actions.select_tab",
    -- ["<C-p>"] = "actions.preview",
    -- ["<C-c>"] = "actions.close",
    ["<C-l>"] = "actions.refresh",
    ["-"] = "actions.parent",
    ["_"] = "actions.open_cwd",
    ["`"] = "actions.cd",
    ["~"] = "actions.tcd",
    ["gs"] = "actions.change_sort",
    ["gx"] = "actions.open_external",
    ["g."] = "actions.toggle_hidden",
  },
  -- Set to false to disable all of the above keymaps
  use_default_keymaps = true,
  view_options = {
    -- Show files and directories that start with "."
    show_hidden = true,
    -- This function defines what is considered a "hidden" file
    is_hidden_file = function(name, bufnr)
      return vim.startswith(name, ".")
    end,
    -- This function defines what will never be shown, even when `show_hidden` is set
    is_always_hidden = function(name, bufnr)
      return false
    end,
    sort = {
      -- sort order can be "asc" or "desc"
      -- see :help oil-columns to see which columns are sortable
      { "type", "asc" },
      { "name", "asc" },
    },
  },
  -- Configuration for the floating window in oil.open_float
  float = {
    -- Padding around the floating window
    padding = 2,
    max_width = 0,
    max_height = 0,
    border = "rounded",
    win_options = {
      winblend = 0,
    },
    -- This is the config that will be passed to nvim_open_win.
    -- Change values here to customize the layout
    override = function(conf)
      return conf
    end,
  },
  -- Configuration for the actions floating preview window
  preview = {
    -- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
    -- min_width and max_width can be a single value or a list of mixed integer/float types.
    -- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
    max_width = 0.9,
    -- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
    min_width = { 40, 0.4 },
    -- optionally define an integer/float for the exact width of the preview window
    width = nil,
    -- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
    -- min_height and max_height can be a single value or a list of mixed integer/float types.
    -- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
    max_height = 0.9,
    -- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
    min_height = { 5, 0.1 },
    -- optionally define an integer/float for the exact height of the preview window
    height = nil,
    border = "rounded",
    win_options = {
      winblend = 0,
    },
  },
  -- Configuration for the floating progress window
  progress = {
    max_width = 0.9,
    min_width = { 40, 0.4 },
    width = nil,
    max_height = { 10, 0.9 },
    min_height = { 5, 0.1 },
    height = nil,
    border = "rounded",
    minimized_border = "none",
    win_options = {
      winblend = 0,
    },
  },
})


vim.keymap.set("n", "<leader>fe", vim.cmd.Oil)


local oil = require("oil")

function symlink_current_item()
  if vim.bo.filetype ~= 'oil' then
    print("This command can only be used in an oil buffer.")
    return
  end

  local entry = oil.get_cursor_entry()
  if not entry then
    print("No item selected")
    return
  end

  local current_dir = oil.get_current_dir()
  local full_path = current_dir .. entry.name

  -- Prompt for sudo
  vim.ui.select({'No', 'Yes'}, {
    prompt = 'Use sudo?',
  }, function(choice)
    local sudo_prefix = choice == 'Yes' and 'sudo ' or ''

    -- Prompt for destination path
    vim.ui.input({
      prompt = "Enter destination path for symlink: ",
      completion = "file"
    }, function(dest_path)
      if not dest_path or dest_path == "" then
        print("Symlink creation cancelled")
        return
      end

      -- Construct the command
      local cmd = sudo_prefix .. 'ln -s ' .. vim.fn.shellescape(full_path) .. ' ' .. vim.fn.shellescape(dest_path)

      -- Open a terminal buffer and run the command
      vim.cmd('botright new')
      local term_buf = vim.api.nvim_get_current_buf()
      vim.fn.termopen(cmd, {
        on_exit = function(job_id, exit_code)
          if exit_code == 0 then
            print("Symlink created successfully")
            vim.api.nvim_buf_delete(term_buf, { force = true })
            oil.discard_all_changes()
          else
            print("Error creating symlink. Check the terminal output.")
          end
        end
      })
      vim.cmd('startinsert')
    end)
  end)
end

vim.api.nvim_create_user_command('OilSymlink', symlink_current_item, {})



-- Define the command
vim.api.nvim_create_user_command('OpenTrashBelow', function()
    -- Create a new window below the current one
    vim.cmd('below split')
    -- Execute the Oil command in the new window
    vim.cmd('Oil --trash /')
    -- -- Resize the new window to a reasonable height (optional)
    -- vim.cmd('resize 15')
end, {})


-- An attempt to make multimarking for oil

-- local M = {}
-- local ns_id = vim.api.nvim_create_namespace('my_highlights')
-- local highlighted_lines = {}
--
-- -- Function to set up action mappings
-- local function setup_action_mappings()
--     vim.keymap.set('n', 'd', function() M.perform_action("delete") end, {buffer = true})
--     vim.keymap.set('n', 'y', function() M.perform_action("copy") end, {buffer = true})
-- end
--
-- -- Function to remove action mappings
-- local function remove_action_mappings()
--     vim.keymap.del('n', 'd', {buffer = true})
--     vim.keymap.del('n', 'y', {buffer = true})
-- end
--
-- M.toggle_highlight = function()
--     local current_line = vim.api.nvim_win_get_cursor(0)[1]
--     vim.api.nvim_buf_add_highlight(0, ns_id, 'Search', current_line - 1, 0, -1)
--     highlighted_lines[current_line] = true
--
--     -- Set up action mappings when first mark is created
--     if next(highlighted_lines) then
--         setup_action_mappings()
--     end
--
--     vim.keymap.set('n', '<Esc>', function()
--         vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
--         highlighted_lines = {}
--         vim.cmd('redraw!')
--         remove_action_mappings()  -- Remove action mappings when marks are cleared
--         vim.keymap.del('n', '<Esc>', { nowait = true })
--     end, { nowait = true })
-- end
--
-- local function get_highlighted_lines()
--     local lines = {}
--     for line, _ in pairs(highlighted_lines) do
--         table.insert(lines, line)
--     end
--     table.sort(lines)
--     return lines
-- end
--
-- M.perform_action = function(action)
--     local lines = get_highlighted_lines()
--     if #lines == 0 then return end
--
--     if action == "delete" then
--         -- Get the lines content first
--         local content = {}
--         for _, lnum in ipairs(lines) do
--             local line = vim.api.nvim_buf_get_lines(0, lnum-1, lnum, false)[1]
--             table.insert(content, line)
--         end
--
--         -- Store in register
--         vim.fn.setreg('"', table.concat(content, '\n'), 'l')
--
--         -- Delete lines from buffer
--         for i = #lines, 1, -1 do  -- Delete from bottom to top
--             vim.api.nvim_buf_set_lines(0, lines[i]-1, lines[i], false, {})
--         end
--     elseif action == "copy" then
--         -- Get the lines content
--         local content = {}
--         for _, lnum in ipairs(lines) do
--             local line = vim.api.nvim_buf_get_lines(0, lnum-1, lnum, false)[1]
--             table.insert(content, line)
--         end
--
--         -- Store in register
--         vim.fn.setreg('"', table.concat(content, '\n'), 'l')
--     end
--
--     vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
--     highlighted_lines = {}
--     remove_action_mappings()  -- Remove action mappings after action is performed
-- end
--
-- vim.api.nvim_create_autocmd("FileType", {
--     pattern = "oil",
--     callback = function()
--         vim.keymap.set('n', 'm', M.toggle_highlight, {buffer = true})
--     end
-- })
--
-- return M
