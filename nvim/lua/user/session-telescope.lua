local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

-- Import your existing logic module
local session = require("user.session")

local M = {}

function M.list_sessions(opts)
  opts = opts or {}

  -- Use the list function from your session.lua
  local sessions = session.list()

  if #sessions == 0 then
    vim.notify("No sessions found")
    return
  end

  pickers.new(opts, {
    prompt_title = "Load Session",
    finder = finders.new_table {
      results = sessions,
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      -- Load on Enter
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        -- Use the load function from your session.lua
        session.load(selection[1])
      end)

      -- Delete on <C-d>
      map("i", "<C-d>", function()
        local selection = action_state.get_selected_entry()
        local session_name = selection[1]

        -- Ask for confirmation
        local choice = vim.fn.confirm("Delete session '" .. session_name .. "'?", "&Yes\n&No", 2)
        if choice == 1 then
            actions.close(prompt_bufnr)
            -- Use the delete function from your session.lua
            session.delete(session_name)
            vim.notify("Deleted session: " .. session_name)
        end
      end)

      return true
    end,
  }):find()
end

return M
