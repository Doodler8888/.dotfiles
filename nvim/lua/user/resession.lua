local resession = require("resession")
require("resession").setup({
  on_load = function()
    vim.cmd('redrawtabline')
    -- Add a small delay and then equalize windows to fix sizing issues
    vim.defer_fn(function()
      vim.cmd('wincmd =')
    end, 10)
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
  --   -- dirvish_extension = {
  --   --   enable_in_tab = true,
  --   --   save_buffers = true,
  --   -- },
  --   -- netrw_extension = {
  --   --   enable_in_tab = true,
  --   --   save_buffers = true,
  --   -- },
    -- folds_extension = {
    --   enable_in_tab = true,
    --   save_buffers = true,
    -- },
    tabs_extension = {
      enable_in_tab = true,
      save_buffers = true,
    },
  },
})

local function rename_session()
    local current = resession.get_current()
    if not current then
        print("No session currently loaded")
        return
    end
    vim.ui.input({ prompt = 'New session name: ' }, function(new_name)
        if new_name and new_name ~= "" then
            resession.delete(current)
            resession.save(new_name)
            print(string.format("Session renamed from '%s' to '%s'", current, new_name))
        end
    end)
end

-- Alternative fix: Add autocmd to equalize windows after session load
vim.api.nvim_create_autocmd("User", {
  pattern = "ResessionLoadPost",
  callback = function()
    vim.defer_fn(function()
      vim.cmd('wincmd =')
    end, 50)
  end,
})

vim.keymap.set('n', '<leader>sr', rename_session, { desc = "Rename session" })
vim.api.nvim_set_keymap('n', '<leader>sl', '<cmd>lua Select_and_load_session_telescope()<CR>', { noremap = true, silent = true })
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

  local custom_opts = vim.tbl_extend("force", opts, {
    layout_strategy = "center",
    layout_config = {
      width = 0.5,
      height = 0.5,
      mirror = false,
      prompt_position = "bottom"
    }
  })

  pickers.new(custom_opts, {
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
    sorter = conf.generic_sorter(custom_opts),
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
  }):find()
end
