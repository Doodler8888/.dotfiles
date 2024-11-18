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

-- Command to get and cd to root
vim.api.nvim_create_user_command('Root', function()
    local current_dir = vim.fn.fnamemodify(get_real_path(), ':h')
    local root = find_root(current_dir)
    vim.cmd('cd ' .. root)
    print('Changed to root: ' .. root)
end, {})

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
vim.keymap.set('n', '<leader>fr', telescope_from_root, {
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
