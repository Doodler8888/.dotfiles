vim.g.mapleader = " "
vim.keymap.set("n", "<leader>fe", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
-- Keep center view
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-f>", "<C-f>zz")
vim.keymap.set("n", "<C-b>", "<C-b>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Start replacing the word that you was on
-- vim.keymap.set("n", "<leader>rr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Make a file executable
vim.keymap.set("n", "<leader>xx", "<cmd>!chmod +x %<CR>", { silent = true })

-- Buffers
-- vim.keymap.set("n", '<S-Tab>', ":b#<CR>")
-- vim.keymap.set("n", '<C-Tab>', ":b#<CR>")
vim.keymap.set("n", "<C-Tab>", ":bprevious<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-Tab>", ":bnext<CR>", { noremap = true, silent = true })

-- Disable Control+c
vim.api.nvim_set_keymap('n', '<C-c>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-c>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-c>', '<Nop>', { noremap = true, silent = true })

-- vim.api.nvim_set_keymap('n', '<Leader>fd', ':find ', {noremap = true})

-- Quit the terminal mode (but not the terminal emulation)
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', {noremap = true})

-- vim.api.nvim_set_keymap('i', '<S-Tab>', [[<C-\><C-o>:normal! 4X<CR>]], { noremap = true, silent = true })

-- Toggle colorcolumn
      vim.cmd('command! Column execute "set colorcolumn=" . (&colorcolumn == "" ? "80" : "")')

-- Keep selection and indent left and right in visual mode
vim.api.nvim_set_keymap('v', '>', '>gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<', '<gv', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<C-t>', 'ZQ', { noremap = true, silent = true })

vim.keymap.set('i', '<C-f>', '<Right>', {noremap = true})
vim.keymap.set('i', '<C-n>', '<Down>', {noremap = true})
vim.keymap.set('i', '<C-b>', '<Left>', {noremap = true})
vim.keymap.set('i', '<C-p>', '<Up>', {noremap = true})
vim.keymap.set('i', '<C-a>', '<Home>', {noremap = true})  -- Start of line
vim.keymap.set('i', '<C-e>', '<End>', {noremap = true})   -- End of line
-- vim.keymap.set('i', '<C-k>', '<Esc><Left><Left>Di', {noremap = true})
vim.api.nvim_set_keymap('i', '<M-f>', '<Esc> ea', {noremap = true})
vim.api.nvim_set_keymap('i', '<C-M-f>', '<Esc> Ea', {noremap = true})
vim.api.nvim_set_keymap('i', '<M-b>', '<Esc> bi', {noremap = true})
vim.api.nvim_set_keymap('i', '<C-M-b>', '<Esc> Bi', {noremap = true})
vim.api.nvim_set_keymap('i', '<M-m>', '<Esc>I', {noremap = true})

-- Cmd line bindings
vim.keymap.set('c', '<C-k>', '<C-\\>e(strpart(getcmdline(), 0, getcmdpos() - 1))<CR>')

local function emacs_kill_line()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local col = cursor[2]
  local line = vim.api.nvim_get_current_line()

  if col >= #line then
    -- At or past end-of-line: do nothing
    return ""
  else
    -- Delete from the cursor to the end of the line, staying in Insert mode.
    return vim.api.nvim_replace_termcodes('<C-o>D', true, true, true)
  end
end
vim.keymap.set('i', '<C-k>', emacs_kill_line, { noremap = true, expr = true })

-- Create a new tab
vim.api.nvim_set_keymap('n', '<Leader>tn', ':tabnew<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>tx', ':tabclose<CR>', {noremap = true, silent = true})


vim.api.nvim_set_keymap('n', '<Leader>cc', ':Cp<CR>', {noremap = true, silent = true})

-- Tables
vim.api.nvim_set_keymap('n', '<Leader>te', ':TableModeToggleeCR>', {noremap = true, silent = true})

-- Move between tabs with
for i = 1, 9 do
     -- vim.api.nvim_set_keymap('n', '<leader>'..i, i..'gt', {noremap = true, silent = true})
	 -- It's mapped to Alt, didn't work the other way, had to use an escape character
	 vim.api.nvim_set_keymap('n', '\27'..i, i..'gt', { noremap = true, silent = true })
end

-- function SwitchTab(num)
--  -- Get the current number of tabs
--  local totalTabs = vim.fn.tabpagenr('$')
--  -- Check if the requested tab number is within the range of existing tabs
--  if num <= totalTabs then
--     vim.cmd('tabnext ' .. num)
--  else
--     -- Optionally, you can print a message or do nothing if the tab doesn't exist
--     -- print("Tab " .. num .. " does not exist.")
--  end
-- end
-- for i = 1, 9 do
--  vim.api.nvim_set_keymap('n', '<C-' .. i .. '>', ':lua SwitchTab(' .. i .. ')<CR>', {noremap = true, silent = true})
-- end

-- vim.api.nvim_set_keymap('n', '<Leader>ee', ':SudaWrite ', {noremap = true})

-- vim.api.nvim_set_keymap('n', '<Leader>te', ':TroubleToggle<CR>', {noremap = true})
-- vim.api.nvim_set_keymap('n', '<M-y>', ':Trouble diagnostics toggle filter.buf=0<CR>', { noremap = true, silent = true })

-- Remove traling spaces
vim.api.nvim_set_keymap('n', '<leader>rw', [[:%s/\s\+$//e<CR>]], {noremap = true, silent = true})

-- Inlay hints
-- vim.keymap.set('n', '<leader>h', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end)

-- Remove persistent highliting after pattern matching actions
vim.api.nvim_set_keymap('n', '<Esc><Esc>', ':noh<CR><Esc>', { noremap = true, silent = true })

-- -- Close a terminal buffer
-- vim.api.nvim_set_keymap('t', '<C-c><C-t>', [[<C-\><C-n>:bd!<CR>]], {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<C-c><C-b>', [[:bd!<CR>]], {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<C-c><C-e>', [[:qa!<CR>]], {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('t', '<C-w>c', '<C-\\><C-n>:q<CR>', {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<Leader>uu', ':UndotreeToggle<CR>', {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<Leader>dd', ':DBUIToggle<CR>', {noremap = true, silent = true})

-- Navigate to the top-right split
vim.api.nvim_set_keymap('n', '<C-w>y', '<Cmd>wincmd t<Bar>wincmd l<CR>', { noremap = true, silent = true })
-- Navigate to the bottom-left split
-- vim.api.nvim_set_keymap('n', '<C-w>bl', '<Cmd>wincmd b<Bar>wincmd h<CR>', { noremap = true, silent = true })

-- For sway
-- vim.keymap.set('n', '<M-/>', '<Nop>', { noremap = true })

-- Require the module
local tabs1 = require('user.tab_rename')
vim.keymap.set('n', '<leader>tr', tabs1.set_tabname, { desc = "Rename tab" })

vim.api.nvim_set_keymap('i', '<C-y>', '<C-R><C-O>+', {noremap = true, silent = true})
vim.cmd([[ cnoremap <C-y> <C-r>+ ]])


-- Add C-x C-s and s bindings
vim.api.nvim_set_keymap('n', '<C-x><C-s>', ':w<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-x>s', ':wa<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-x><C-e>', ':wqa<CR>', {noremap = true, silent = true})

vim.api.nvim_set_keymap('c', '<C-g>', '<C-c>', { noremap = true })


vim.keymap.set('n', '<C-x><C-f>', function()
    local current_path = vim.fn.fnamemodify(vim.fn.expand('%'), ':p')
    vim.fn.feedkeys(':e ' .. current_path, 'n')
end, {noremap = true})



