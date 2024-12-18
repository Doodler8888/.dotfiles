local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")


local function show_command_history_telescope()
  -- Retrieve all command history
  local history = vim.fn.execute('history cmd')
  local lines = vim.split(history, '\n')

  -- Remove the header and empty lines
  table.remove(lines, 1)
  lines = vim.tbl_filter(function(line) return line ~= '' end, lines)

  -- Commands to filter out
  local filter_out = {
    w = true,
    so = true,
    wa = true,
    wqa = true,
    s = true,
  }

  -- Clean the commands (remove line numbers), reverse the order, and filter out unwanted commands
  local cleaned_commands = {}
  for i = #lines, 1, -1 do  -- Iterate in reverse order
    local line = lines[i]
    local _, _, cmd = string.find(line, "%s*%d+%s+(.*)")
    if cmd and not filter_out[cmd] then
      table.insert(cleaned_commands, cmd)
    end
  end

  -- Create a Telescope picker
  pickers.new({}, {
    prompt_title = "Command History",
    finder = finders.new_table {
      results = cleaned_commands,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry,
          ordinal = entry,
        }
      end,
    },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        -- Insert the selected command into the command line
        vim.fn.feedkeys(":" .. selection.value, "n")
      end)

      return true
    end,
  }):find()
end



-- Create the keybinding
vim.api.nvim_create_autocmd("CmdlineEnter", {
  callback = function()
    vim.keymap.set("c", "<C-f>", function()
      -- Save the current command-line content
      local current_cmd = vim.fn.getcmdline()
      local current_pos = vim.fn.getcmdpos()

      -- Exit command-line mode
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)

      -- Call the function after a short delay
      vim.defer_fn(function()
        show_command_history_telescope()
      end, 10)
    end, { buffer = true, silent = true })
  end
})
