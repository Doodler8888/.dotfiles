-- require("quicker").setup()


-- -- Function to toggle quickfix with LSP diagnostics for the current buffer
-- local function toggle_quickfix_diagnostics()
--     local qf_exists = false
--     for _, win in pairs(vim.fn.getwininfo()) do
--         if win["quickfix"] == 1 then
--             qf_exists = true
--         end
--     end
--
--     if qf_exists then
--         vim.cmd("cclose")
--     else
--         -- Store the current window number
--         local current_win = vim.api.nvim_get_current_win()
--
--         -- Get diagnostics for the current buffer
--         local diagnostics = vim.diagnostic.get(0)
--
--         -- Convert diagnostics to quickfix items
--         local qf_items = {}
--         for _, d in ipairs(diagnostics) do
--             table.insert(qf_items, {
--                 bufnr = d.bufnr,
--                 lnum = d.lnum + 1,
--                 col = d.col + 1,
--                 text = d.message,
--                 type = d.severity == vim.diagnostic.severity.ERROR and 'E'
--                     or d.severity == vim.diagnostic.severity.WARN and 'W'
--                     or d.severity == vim.diagnostic.severity.INFO and 'I'
--                     or 'H'
--             })
--         end
--
--         -- Set the quickfix list
--         vim.fn.setqflist(qf_items)
--
--         -- Open the quickfix window at the bottom of all windows
--         vim.cmd("botright copen")
--
--         -- Return focus to the original window
--         vim.api.nvim_set_current_win(current_win)
--     end
-- end
--

-- Keybinding to toggle quickfix with LSP diagnostics
-- vim.keymap.set('n', '<M-y>', toggle_quickfix_diagnostics, { noremap = true, silent = true, desc = "Toggle quickfix with current buffer diagnostics" })
-- vim.keymap.set('v', '<M-y>', toggle_quickfix_diagnostics, { noremap = true, silent = true, desc = "Toggle quickfix with current buffer diagnostics" })


vim.api.nvim_set_keymap('n', '<M-y>', ':lua ToggleCopen()<CR>', { noremap = true, silent = true })

function ToggleCopen()
  -- Get all window info
  local windows = vim.fn.getwininfo()
  local quickfix_open = false
  -- Check if any window is a quickfix window
  for _, win in ipairs(windows) do
    if win.quickfix == 1 then
      quickfix_open = true
      break
    end
  end
  -- Toggle quickfix window
  if quickfix_open then
    vim.cmd('cclose')
  else
    vim.cmd('copen')
  end
end

-- Keybindings to navigate quickfix items
vim.keymap.set('n', '<C-M-n>', ':cnext<CR>', { noremap = true, silent = true, desc = "Next quickfix item" })
vim.keymap.set('v', '<C-M-n>', ':cnext<CR>', { noremap = true, silent = true, desc = "Next quickfix item" })
-- vim.keymap.set('n', '<M-n>', ':cnext<CR>', { noremap = true, silent = true, desc = "Next quickfix item" })
-- vim.keymap.set('v', '<M-j>', ':cnext<CR>', { noremap = true, silent = true, desc = "Next quickfix item" })
vim.keymap.set('n', '<C-M-p>', ':cprev<CR>', { noremap = true, silent = true, desc = "Previous quickfix item" })
vim.keymap.set('v', '<C-M-p>', ':cprev<CR>', { noremap = true, silent = true, desc = "Previous quickfix item" })
-- vim.keymap.set('n', '<M-p>', ':cprev<CR>', { noremap = true, silent = true, desc = "Previous quickfix item" })
-- vim.keymap.set('v', '<M-k>', ':cprev<CR>', { noremap = true, silent = true, desc = "Previous quickfix item" })
