vim.g.mapleader = " "
-- vim.keymap.set("n", "<leader>fe", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
-- Keep center view
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Void a pasted upon word
vim.keymap.set("x", "<C-y>", [["_dP]])

-- Start replacing the word that you was on
vim.keymap.set("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Make a file executable
vim.keymap.set("n", "<leader>xx", "<cmd>!chmod +x %<CR>", { silent = true })

-- Buffers
vim.keymap.set("n", '<S-Tab>', ":b#<CR>")

-- Disable Control+c  
vim.api.nvim_set_keymap('n', '<C-c>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-c>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-c>', '<Nop>', { noremap = true, silent = true })

-- vim.api.nvim_set_keymap('n', '<Leader>fd', ':find ', {noremap = true})

-- Quit the terminal mode (but not the terminal emulation)
vim.api.nvim_set_keymap('t', '<S-Tab>', '<C-\\><C-n>', {noremap = true})

-- vim.api.nvim_set_keymap('i', '<S-Tab>', [[<C-\><C-o>:normal! 4X<CR>]], { noremap = true, silent = true })

-- Toggle colorcolumn
vim.cmd('command! Column execute "set colorcolumn=" . (&colorcolumn == "" ? "80" : "")')

-- Keep selection and indent left and right in visual mode
vim.api.nvim_set_keymap('v', '>', '>gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<', '<gv', { noremap = true, silent = true })

-- Motion shortcuts
vim.api.nvim_set_keymap('i', '<C-f>', '<Esc>la', {noremap = true})
vim.api.nvim_set_keymap('i', '<C-b>', '<Esc>ha', {noremap = true})
vim.api.nvim_set_keymap('i', '<M-w>', '<Esc> wi', {noremap = true})
vim.api.nvim_set_keymap('i', '<M-b>', '<Esc> bi', {noremap = true})
vim.api.nvim_set_keymap('i', '<M-i>', '<Esc>I', {noremap = true})
vim.api.nvim_set_keymap('i', '<M-a>', '<Esc>A', {noremap = true})

-- Create a new tab with 'Alt-T'
vim.api.nvim_set_keymap('n', '<Leader>tn', ':tabnew<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>tx', ':tabclose<CR>', {noremap = true, silent = true})

-- Move between tabs with 
for i = 1, 9 do
  vim.api.nvim_set_keymap('n', '<leader>'..i, i..'gt', {noremap = true, silent = true})
end

-- vim.api.nvim_set_keymap('n', '<Leader>ee', ':SudaWrite ', {noremap = true})

vim.api.nvim_set_keymap('n', '<Leader>tt', ':Trouble<CR>', {noremap = true})
