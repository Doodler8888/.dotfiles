-- Helper functions
local function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

local function findLast(haystack, needle)
    local i=haystack:match(".*"..needle.."()")
    if i==nil then return nil else return i-1 end
end

local function parent_dir(dir)
  return dir:sub(1, findLast(dir, '/')-1)
end

-- Get real path handling oil buffers
local function get_real_path()
    local path = vim.fn.expand('%:p')
    if vim.bo.filetype == 'oil' then
        path = path:gsub("^oil://", "")
    end
    return path
end

-- Root patterns to look for
local root_patterns = {
    '.git',
    'lazy-lock.json',
    '.zshrc',
    'help-files',
}

-- Function to find project root
local function find_root(start_dir)
    local term_pattern = parent_dir(os.getenv('HOME'))
    local prefix = start_dir

    if not (prefix:find(term_pattern) == 1) then
        return start_dir
    end

    while prefix ~= term_pattern do
        for _, pattern in ipairs(root_patterns) do
            if file_exists(prefix .. '/' .. pattern) then
                return prefix
            end
        end
        prefix = parent_dir(prefix)
    end

    return start_dir
end


-- -- Autocmd
--
-- local aug = vim.api.nvim_create_augroup('ProjectRootChanger', { clear = true })
--
-- vim.api.nvim_create_autocmd('BufEnter', {
--   group = aug,
--   pattern = '*', -- Run for all buffers
--   callback = function()
--     -- ============================ THE FIX ============================ --
--     -- 1. First, check if the buffer is a "special" buffer (not a normal file).
--     --    Normal file buffers have an empty 'buftype'. If it's not empty,
--     --    it's a help page, terminal, quickfix list, etc. We should ignore it.
--     if vim.bo.buftype ~= '' then
--       return
--     end
--     -- ================================================================= --
--
--     local buf_path = vim.api.nvim_buf_get_name(0)
--
--     -- This check is still useful for new, unsaved buffers.
--     if buf_path == '' then
--       return
--     end
--
--     local file_dir = vim.fn.fnamemodify(buf_path, ':h')
--
--     -- ============================ THE FIX ============================ --
--     -- 2. Add a sanity check to ensure we're not dealing with a weird path
--     --    like "health:" that isn't a real directory.
--     if vim.fn.isdirectory(file_dir) == 0 then
--       return
--     end
--     -- ================================================================= --
--
--     local project_root = find_root(file_dir)
--     local current_lcd = vim.fn.getcwd(0)
--
--     if project_root and project_root ~= current_lcd then
--       vim.cmd.lcd(project_root)
--     end
--   end,
-- })


-- Command to get and cd to root
vim.api.nvim_create_user_command('Root', function()
    local current_dir = vim.fn.fnamemodify(get_real_path(), ':h')
    local root = find_root(current_dir)
    vim.cmd('lcd ' .. root)
    print('Changed to root: ' .. root)
end, {})

vim.keymap.set('n', '<leader>ro', ':Root<CR>', {noremap = true, silent = true})

-- Function to search files from root with Telescope
local function telescope_from_root()
    local current_dir = vim.fn.fnamemodify(get_real_path(), ':h')
    local root = find_root(current_dir)
    require('telescope.builtin').find_files({
        cwd = root,
        hidden = true,
        follow = true,
    })
end

-- Telescope keybinding
vim.keymap.set('n', '<leader>fp', telescope_from_root, {
    noremap = true,
    silent = true,
    desc = "Find files from project root"
})

-- -- Autocmd to change local directory to root
-- vim.api.nvim_create_autocmd("BufEnter", {
--     callback = function()
--         -- Skip certain filetypes where changing directory might not be desired
--         local ignored_filetypes = {
--             "fugitive",
--             "help",
--             "quickfix",
--             "qf",
--             "TelescopePrompt",
--         }
--
--         if vim.tbl_contains(ignored_filetypes, vim.bo.filetype) then
--             return
--         end
--
--         -- Get the real path and find root
--         local current_dir = vim.fn.fnamemodify(get_real_path(), ':h')
--         local root = find_root(current_dir)
--
--         -- Change local directory to root
--         vim.cmd('lcd ' .. root)
--     end,
--     desc = "Auto change local directory to project root"
-- })
