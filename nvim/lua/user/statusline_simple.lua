-- Function to get Git branch using Vim-fugitive
function GetGitBranch()
    local branch = vim.fn.FugitiveHead()
    if branch and #branch > 0 then
        return '[' .. branch .. ']'
    end
    return ''
end

-- function GetGitBranch()
--     local handle = io.popen("git branch --show-current 2>/dev/null")
--     if handle then
--         local branch = handle:read("*a"):gsub("\n", "")
--         handle:close()
--         if branch and #branch > 0 then
--             return '[' .. branch .. ']'
--         end
--     end
--     return ''
-- end

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
