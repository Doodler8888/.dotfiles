local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local previewers = require("telescope.previewers")

local function search_shell_commands()
  -- Store the current mode and cursor position at the start
  local mode = vim.api.nvim_get_mode().mode
  local was_visual = mode:match('^[vV\22]') -- v, V, or <C-v>
  local start_pos = vim.api.nvim_win_get_cursor(0)

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
      local function on_select(should_copy)
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          local lnum = selection.lnum
          
          if should_copy then
            -- Determine the direction of selection
            local start_line = start_pos[1]
            local end_line = lnum
            local reverse = start_line > end_line

            -- Set the start and end of the selection
            if reverse then
              vim.api.nvim_win_set_cursor(0, {start_line, 0})
              vim.cmd('normal! v')
              vim.api.nvim_win_set_cursor(0, {end_line, 0})
            else
              vim.api.nvim_win_set_cursor(0, {start_line, 0})
              vim.cmd('normal! v')
              vim.api.nvim_win_set_cursor(0, {end_line, 0})
              vim.cmd('normal! $')
            end

            -- Copy the selection
            vim.cmd('normal! y')
            print("Text copied from line " .. start_line .. " to " .. end_line)
          else
            -- Just move the cursor to the selected line
            vim.api.nvim_win_set_cursor(0, { lnum, 0 })
            vim.cmd('normal! zz')
          end

          if was_visual then
            vim.cmd('normal! <C-v>')
          end
        else
          print('No selection made.')
        end
      end

      -- Map both normal mode and visual mode actions
      map('i', '<CR>', function() on_select(false) end)
      map('n', '<CR>', function() on_select(false) end)

      -- Add mappings for copying using M-w
      map('i', '<M-w>', function() on_select(true) end)
      map('n', '<M-w>', function() on_select(true) end)

      -- Keep your existing visual mode mappings
      map('i', '<C-v>', function()
        on_select(false)
        vim.cmd('normal! <C-v>')
      end)
      map('n', '<C-v>', function()
        on_select(false)
        vim.cmd('normal! <C-v>')
      end)

      return true
    end,
  }):find()
end

vim.api.nvim_create_user_command('SearchShellCommands', search_shell_commands, { range = true })

vim.api.nvim_set_keymap('n', '<C-s><C-o>', ':SearchShellCommands<CR>', { noremap = true, silent = true })
