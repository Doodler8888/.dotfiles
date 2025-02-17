-- -- Function to run Git diff in a vertical split on the right side
-- function Git_right()
--     vim.cmd('rightbelow vertical Git')
-- end
--
-- -- Function to set up Fugitive-specific keybindings
-- vim.api.nvim_set_keymap('n', '<C-x>g', ':lua Git_right()<CR>', { noremap = true, silent = true })


function OpenFugitiveInNewTab()
    vim.cmd('tab Git')  -- Open Fugitive in new tab
end

vim.api.nvim_set_keymap(
    'n',
    '<leader>gt',  -- Suggested mapping: <leader>gt for "Git Tab"
    ':lua OpenFugitiveInNewTab()<CR>',
    { noremap = true, silent = true }
)


-- function OpenFugitiveInFloat()
--     local width = math.floor(vim.o.columns * 0.8)
--     local height = math.floor(vim.o.lines * 0.8)
--
--     -- Create floating window
--     local win = vim.api.nvim_open_win(0, true, {
--         relative = 'editor',
--         width = width,
--         height = height,
--         col = (vim.o.columns - width) * 0.5,
--         row = (vim.o.lines - height) * 0.5,
--         style = 'minimal',
--         border = 'rounded'
--     })
--
--     -- Run Git command in floating window
--     vim.cmd('Git')
-- end
--
-- vim.api.nvim_set_keymap(
--     'n',
--     '<leader>gf',  -- Suggested mapping: <leader>gf for "Git Float"
--     ':lua OpenFugitiveInFloat()<CR>',
--     { noremap = true, silent = true }
-- )
