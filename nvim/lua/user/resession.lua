local resession = require("resession")
require("resession").setup({
  on_load = function()
    vim.cmd('redrawtabline')
  end,
  autosave = {
    enabled = false,
    interval = 30,
    notify = false,
  },
  options = {
    "binary",
    "bufhidden",
    "buflisted",
    "cmdheight",
    "diff",
    "filetype",
    "modifiable",
    "previewwindow",
    "readonly",
    "scrollbind",
    "winfixheight",
    "winfixwidth",
  },
  extensions = {
    oil_extension = {
      enable_in_tab = true,
      save_buffers = true,
    },
    folds_extension = {
      enable_in_tab = true,
      save_buffers = true,
    },
    -- tab_rename_extension = {
    --   save_global = true,
    -- },
  },
})

vim.keymap.set("n", "<leader>ss", resession.save)
-- vim.keymap.set("n", "<leader>sl", resession.load)
vim.keymap.set("n", "<leader>sd", resession.delete)

vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        if require('resession').get_current() ~= nil then
          require('resession').save()
        end
      end,
})


local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local action_state = require('telescope.actions.state')
local actions = require('telescope.actions')

function Select_and_load_session_telescope(opts)
  opts = opts or {}

  local sessions = require('resession').list()

  if #sessions == 0 then
    print("No sessions found.")
    return
  end

  -- Custom layout configuration
  local layout_config = {
    width = 0.5, -- Width of the Telescope window as a fraction of the total width
    height = 0.5, -- Height of the Telescope window as a fraction of the total height
    mirror = false, -- Whether to mirror the layout
    strategy = "center", -- Use the center strategy to automatically center the window
  }

  pickers.new(opts, {
    prompt_title = 'Load Session',
    finder = finders.new_table {
      results = sessions,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry,
          ordinal = entry,
        }
      end,
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      local function load_selected_session()
        local selection = action_state.get_selected_entry()
        if selection then
          actions.close(prompt_bufnr)
          require('resession').load(selection.value)
        else
          print("No session selected.")
        end
      end

      map('i', '<CR>', load_selected_session)
      map('n', '<CR>', load_selected_session)

      return true
    end,
    layout_config = layout_config, -- Apply the custom layout configuration
  }):find()
end


-- Keybinding Example (Neovim Lua configuration)
vim.api.nvim_set_keymap('n', '<leader>sl', '<cmd>lua Select_and_load_session_telescope()<CR>', { noremap = true, silent = true })

-- vim.api.nvim_create_autocmd("VimLeavePre", {
--   callback = function()
--     require('resession').save()
--   end,
-- })
--
-- vim.api.nvim_create_autocmd("VimLeavePre", {
--   callback = function()
--     -- Always save a special session named "last"
--     resession.save("last")
--   end,
-- })
