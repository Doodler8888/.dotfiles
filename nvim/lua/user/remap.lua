vim.g.mapleader = " "
-- vim.keymap.set("n", "<leader>fe", vim.cmd.Ex)

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
vim.keymap.set("n", '<S-Tab>', ":b#<CR>")
-- vim.keymap.set("n", '<C-Tab>', ":b#<CR>") -- Probably doesn't work because it's not supported by my terminal.
-- vim.api.nvim_set_keymap('n', '<C-Tab>', ':b#<CR>', { noremap = true, silent = true })

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

-- Motion shortcuts
vim.api.nvim_set_keymap('i', '<C-l>', '<Esc>la', {noremap = true})
vim.api.nvim_set_keymap('i', '<C-h>', '<Esc>ha', {noremap = true})
vim.api.nvim_set_keymap('i', '<M-w>', '<Esc> wi', {noremap = true})
vim.api.nvim_set_keymap('i', '<M-W>', '<Esc> Wi', {noremap = true})
vim.api.nvim_set_keymap('i', '<M-b>', '<Esc> bi', {noremap = true})
vim.api.nvim_set_keymap('i', '<M-B>', '<Esc> Bi', {noremap = true})
vim.api.nvim_set_keymap('i', '<M-i>', '<Esc>I', {noremap = true})
vim.api.nvim_set_keymap('i', '<M-a>', '<Esc>A', {noremap = true})

-- Create a new tab
vim.api.nvim_set_keymap('n', '<Leader>tn', ':tabnew<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>tx', ':tabclose<CR>', {noremap = true, silent = true})

-- Tables
vim.api.nvim_set_keymap('n', '<Leader>te', ':TableModeToggleeCR>', {noremap = true, silent = true})

-- -- Move between tabs with 
for i = 1, 9 do
     vim.api.nvim_set_keymap('n', '<leader>'..i, i..'gt', {noremap = true, silent = true})
     -- vim.api.nvim_set_keymap('n', ','..i, i..'gt', {noremap = true, silent = true})
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
-- vim.api.nvim_set_keymap('n', '<M-y>', ':TroubleToggle<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<M-y>', ':TroubleToggle document_diagnostics<CR>', { noremap = true, silent = true })

-- Remove traling spaces
vim.api.nvim_set_keymap('n', '<leader>rw', [[:%s/\s\+$//e<CR>]], {noremap = true, silent = true})

-- Inlay hints
-- vim.keymap.set('n', '<leader>h', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end)

-- Remove persistent highliting after pattern matching actions
vim.api.nvim_set_keymap('n', '<Esc><Esc>', ':noh<CR><Esc>', { noremap = true, silent = true })

-- Close a terminal buffer
vim.api.nvim_set_keymap('t', '<C-c><C-t>', [[<C-\><C-n>:bd!<CR>]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-c><C-b>', [[:bd!<CR>]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-c><C-e>', [[:qa!<CR>]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('t', '<C-w>c', '<C-\\><C-n>:q<CR>', {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<Leader>uu', ':UndotreeToggle<CR>', {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<Leader>dd', ':DBUIToggle<CR>', {noremap = true, silent = true})

-- Navigate to the top-right split
vim.api.nvim_set_keymap('n', '<C-w>y', '<Cmd>wincmd t<Bar>wincmd l<CR>', { noremap = true, silent = true })
-- Navigate to the bottom-left split
-- vim.api.nvim_set_keymap('n', '<C-w>bl', '<Cmd>wincmd b<Bar>wincmd h<CR>', { noremap = true, silent = true })

-- For sway
-- vim.keymap.set('n', '<M-/>', '<Nop>', { noremap = true })

