-- Function to get Git branch using Vim-fugitive
function GetGitBranch()
    local branch = vim.fn.FugitiveHead()
-- local branch = vim.trim(vim.fn.system("git branch --format='%(refname:short)' 2>/dev/null | head -n1"))
    if branch and #branch > 0 then
        return '[' .. branch .. ']'
    end
    return ''
end

-- Function to format the file path

function FormatFilePath()
  local full_path = vim.fn.expand('%:p')
  local home_dir = vim.fn.expand('$HOME')

  -- Replace home directory with ~
  full_path = full_path:gsub('^' .. home_dir, '~')
  return full_path
end


-- Set the statusline
vim.o.statusline = '%{winnr()} %{%v:lua.FormatFilePath()%} %{%v:lua.GetGitBranch()%}'
-- vim.o.statusline = '%{winnr()} %{%v:lua.FormatFilePath()%}'



-- -- Global function to format the file path (replacing $HOME with ~)
-- function _G.format_file_path()
--   local full_path = vim.fn.expand('%:p')
--   local home_dir = vim.fn.expand('$HOME')
--   return full_path:gsub('^' .. home_dir, '~')
-- end
--
-- -- Function to get the Git branch for the current file's directory
-- local function get_git_branch()
--   if vim.fn.expand('%:p') == "" then
--     return ''
--   end
--
--   local ft = vim.bo.filetype
--   if ft:match("^Telescope") then
--     return ''
--   end
--
--   -- Use the directory of the file. For netrw buffers, use its current directory.
--   local file_dir = vim.fn.expand('%:p:h')
--   if ft == 'netrw' then
--     file_dir = vim.b.netrw_curdir or vim.fn.getcwd()
--   end
--
--   if file_dir == '' or vim.fn.isdirectory(file_dir) == 0 then
--     return ''
--   end
--
--   local git_cmd = "git -C " .. vim.fn.shellescape(file_dir) .. " branch --show-current 2>/dev/null"
--   local branch = vim.fn.system(git_cmd)
--   branch = vim.trim(branch)
--   if branch ~= "" then
--     return '[' .. branch .. ']'
--   end
--   return ''
-- end
--
-- -- Update the branch variable when a buffer is entered or when it first appears in a window.
-- vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
--   pattern = "*",
--   callback = function()
--     vim.b.git_branch = get_git_branch()
--   end,
-- })
--
-- -- Additionally, on VimEnter (after startup/session load), update all visible windows.
-- vim.api.nvim_create_autocmd("VimEnter", {
--   pattern = "*",
--   callback = function()
--     -- Use a short delay to ensure everything is loaded.
--     vim.defer_fn(function()
--       for _, win in ipairs(vim.api.nvim_list_wins()) do
--         local buf = vim.api.nvim_win_get_buf(win)
--         vim.api.nvim_buf_set_var(buf, 'git_branch', get_git_branch())
--       end
--     end, 50)
--   end,
-- })
--
-- -- Set the statusline. It shows the window number, formatted file path, and the git branch.
-- vim.o.statusline = '%{winnr()} %{v:lua.format_file_path()} %{get(b:,"git_branch","")}'
