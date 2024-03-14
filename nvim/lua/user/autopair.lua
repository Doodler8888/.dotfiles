-- Initialize the autopair_enabled variable
vim.g.autopair_enabled = true

-- Define the toggle function
_G.autopair_toggle = function()
  if vim.g.autopair_enabled == true then
    vim.g.autopair_enabled = false
  else
    vim.g.autopair_enabled = true
  end
end

-- Autopair
_G.autopair = function()
  if vim.g.autopair_enabled == true then
    -- vim.api.nvim_set_keymap("i", "'", "''<left>", {noremap = true, silent = true})
    vim.api.nvim_set_keymap("i", "\"", "\"\"<left>", {noremap = true, silent = true})
    vim.api.nvim_set_keymap("i", "(", "()<left>", {noremap = true})
    vim.api.nvim_set_keymap("i", "[", "[]<left>", {noremap = true})
    vim.api.nvim_set_keymap("i", "{", "{}<left>", {noremap = true})
    -- vim.api.nvim_set_keymap("i", "{;", "{};<left><left>", {noremap = true})
  else
    -- Remove the auto-pairing by setting to self insertations
    -- vim.api.nvim_set_keymap("i", "'", "'", {noremap = true, silent = true})
    vim.api.nvim_set_keymap("i", "\"", "\"", {noremap = true, silent = true})
    vim.api.nvim_set_keymap("i", "(", "(", {noremap = true})
    vim.api.nvim_set_keymap("i", "[", "[", {noremap = true})
    vim.api.nvim_set_keymap("i", "{", "{", {noremap = true})
    vim.api.nvim_set_keymap("i", "{;", "{;", {noremap = true})
  end
end

-- Call the function on Vim startup
_G.autopair()

-- Map a key (F5) to toggle auto-pairing
-- vim.api.nvim_set_keymap("n", "<F5>", ":lua _G.autopair_toggle()<CR>:lua _G.autopair()<CR>", {noremap = true, silent = true})

local opening_pairs = { '(', '{', '[', '<', '\'', '\"' }
for _, pair in ipairs(opening_pairs) do
    -- map <M-char> to insert the character literally, in insert mode
    vim.api.nvim_set_keymap('i', '<M-'..pair..'>', pair, { noremap = true })
end

local closing_pairs = { ')', '}', ']', '>', '\'', '\"' }
for _, pair in ipairs(closing_pairs) do
    -- map <M-char> to insert the character literally, in insert mode
    vim.api.nvim_set_keymap('i', '<M-'..pair..'>', pair, { noremap = true })
end

-- vim.api.nvim_set_keymap('n', '<F5>', ':!ormolu -m inplace %<CR>', { noremap = true, silent = true })
