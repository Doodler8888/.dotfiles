require('telescope').setup{
 defaults = {
 find_command = { 'fd', '--type=f', '--hidden', '--exclude=.git', '--exclude=node_modules' },
 },
 extensions = {
 fzf = {
   fuzzy = true,               -- false will only do exact matching
   override_generic_sorter = true, -- override the generic sorter
   override_file_sorter = true,  -- override the file sorter
   case_mode = "smart_case",     -- or "ignore_case" or "respect_case"
                               -- the default case_mode is "smart_case"
 },
 persisted = {
  layout_config = { width = 0.55, height = 0.55 }
 },
 zoxide = {}
 }
}

require('telescope').load_extension('fzf')
-- require("telescope").load_extension("persisted")
-- require('telescope').load_extension('zoxide')

vim.api.nvim_set_keymap('n', '<leader>tf', [[<cmd>lua require('telescope.builtin').find_files({ hidden = true, sort = true })<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>th', [[<Cmd>lua require('telescope.builtin').find_files({ hidden = true, sort = true, cwd = '~/' })<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ts', [[<cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep > ") })<CR>]], { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>fp', [[<cmd>Telescope persisted<CR>]], { noremap = true, silent = true })


_G.telescope_home_dirs = function(opts)
  opts = opts or {}
  local action_state = require('telescope.actions.state')
  local actions = require('telescope.actions')
  local home = vim.fn.expand("~") -- Expand the home directory

  require('telescope.builtin').find_files({
    prompt_title = "Home Directories",
    cwd = home, -- Use the expanded home directory
    find_command = { 'fd', '--type', 'd', '.', '--hidden', '--exclude', '.git', home },
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr) -- Close the Telescope picker
        local selection = action_state.get_selected_entry() -- Get the selected directory
        local path = vim.fn.fnamemodify(selection[1], ":p") -- Get the full path
        -- Change the directory for the current window
        vim.cmd("lcd " .. vim.fn.fnameescape(path))
        -- Open the oil buffer for the chosen directory
        vim.cmd("Oil " .. vim.fn.fnameescape(path))
      end)
      return true
    end
  })
end

-- You can then map this function to a command or keybinding
vim.cmd([[command! TelescopeHomeDirs lua _G.telescope_home_dirs()]])
vim.keymap.set('n', '<Leader>tdh', _G.telescope_home_dirs)


-- -- Function to insert a path based on a static value
-- _G.telescope_insert_path = function()
--  require('telescope.builtin').file_browser({
--    prompt_title = "Insert Path",
--    cwd = "/", -- Start in the root directory
--    hidden = true, -- Show hidden files
--    exclude = { "var", "opt", "lib", "lib64", "mnt", "proc", "run", "sbin", "srv", "sys", "tmp" }, -- Exclude certain directories
--  })
-- end
--
-- -- Function to insert a path based on a dynamic value on the left from the cursor
-- _G.telescope_insert_dynamic_path = function()
--  -- Get the current line and cursor position
--  local line = vim.api.nvim_get_current_line()
--  local col = vim.api.nvim_win_get_cursor(0)[2]
--
--  -- Get the path fragment to the left of the cursor
--  local path_fragment = line:sub(1, col):match("([^%s]+)$")
--
--  -- If there's no path fragment found, default to searching from the current directory
--  if not path_fragment or path_fragment == "" then
--    path_fragment = "."
--  end
--
--  -- Run the Telescope file_browser with the dynamic path fragment
--  require('telescope.builtin').file_browser({
--    prompt_title = "Insert Dynamic Path",
--    cwd = path_fragment, -- Start in the dynamic path fragment
--    hidden = true, -- Show hidden files
--    exclude = { "var", "opt", "lib", "lib64", "mnt", "proc", "run", "sbin", "srv", "sys", "tmp" }, -- Exclude certain directories
--  })
-- end
--
-- -- Map these functions to keybindings
-- vim.cmd([[command! TelescopeInsertPath lua _G.telescope_insert_path()]])
-- vim.cmd([[command! TelescopeInsertDynamicPath lua _G.telescope_insert_dynamic_path()]])
-- vim.keymap.set('i', '<Leader>ty', '<cmd>lua _G.telescope_insert_path()<CR>', {silent = true, desc = "Insert Path"})
-- vim.keymap.set('i', '<Leader>tl', '<cmd>lua _G.telescope_insert_dynamic_path()<CR>', {silent = true, desc = "Insert Dynamic Path"})
