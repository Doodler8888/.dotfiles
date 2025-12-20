vim.cmd([[ set wildmode=longest:full ]])
vim.opt.completeopt = { "menuone", "noselect", "popup", "fuzzy" }


vim.cmd([[inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"]])
vim.cmd([[cnoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<C-z>"]])




-- -- Set completeopt for better completion experience
-- vim.o.completeopt = 'menu,menuone,noinsert,noselect,longest'
--
--
-- -- Avoid showing extra messages when using completion
-- vim.o.shortmess = vim.o.shortmess .. 'c'
--
-- -- Function to check if completion menu is visible
-- local function completion_menu_visible()
--   return vim.fn.pumvisible() == 1
-- end
--
-- -- Function to return the appropriate key command
-- local function completion_key_map(key)
--   if completion_menu_visible() then
--     return key
--   else
--     return '<C-s><C-o>' .. key
--   end
-- end
--
--
--
-- -- Make the functions globally accessible
-- _G.completion_menu_visible = completion_menu_visible
-- _G.completion_key_map = completion_key_map
--
-- -- Insert mode mappings for controlling completion menu
-- -- vim.api.nvim_set_keymap('i', '<C-Space>', "v:lua.completion_key_map('<C-n>')", {expr = true, noremap = true})
-- -- vim.api.nvim_set_keymap('i', '<C-n>', "v:lua.completion_key_map('<C-n>')", {expr = true, noremap = true})
-- -- vim.api.nvim_set_keymap('i', '<C-p>', "v:lua.completion_key_map('<C-p>')", {expr = true, noremap = true})
--
-- -- Insert mode mapping to accept the current suggestion with Ctrl-a
-- vim.api.nvim_set_keymap('i', '<C-a>', '<C-y>', {noremap = true})
--
-- -- Command mode mapping for Tab to invoke completion without autofill
-- vim.cmd([[inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"]])
-- vim.cmd([[cnoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<C-z>"]])
-- vim.cmd([[cnoremap <C-z> <C-r>=pumvisible() ? "\<lt>Down>" : "\<lt>Tab>"<CR>"]])
--
--
