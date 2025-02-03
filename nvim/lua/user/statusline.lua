-- Function to get Git branch using Vim-fugitive
function GetGitBranch()
    -- local branch = vim.fn.FugitiveHead()
local branch = vim.trim(vim.fn.system("git branch --format='%(refname:short)' 2>/dev/null | head -n1"))
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

    -- Split the path into directories
    local dirs = vim.fn.split(full_path, '/')
    local formatted_path = {}

    -- Format all directories except the last one (filename)
    for i = 1, #dirs - 1 do
        local dir = dirs[i]
        if dir:sub(1, 1) == '.' and #dir > 1 then
            -- For hidden directories, keep the dot and the next character
            table.insert(formatted_path, dir:sub(1, 2))
        else
            -- For normal directories, just keep the first character
            table.insert(formatted_path, dir:sub(1, 1))
        end
    end

    -- Add the full filename
    table.insert(formatted_path, dirs[#dirs])

    -- Join the formatted path
    return table.concat(formatted_path, '/')
end

-- Set the statusline
vim.o.statusline = '%{winnr()} %{%v:lua.FormatFilePath()%} %{%v:lua.GetGitBranch()%}'

vim.cmd([[ set wildmode=longest:full ]])
