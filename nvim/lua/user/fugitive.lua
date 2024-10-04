-- Function to run Git diff in a vertical split on the right side
function Git_right()
    vim.cmd('rightbelow vertical Git')
end

-- Function to set up Fugitive-specific keybindings
vim.api.nvim_set_keymap('n', '<C-x>g', ':lua Git_right()<CR>', { noremap = true, silent = true })
