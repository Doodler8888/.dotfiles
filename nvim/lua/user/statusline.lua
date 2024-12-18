function GetCurrentBranch()
    local branch_name = vim.fn.system("git rev-parse --abbrev-ref HEAD 2>/dev/null"):gsub("\n", "")
    if vim.v.shell_error == 0 then
        return branch_name
    end
    return ""
end

function SetStatusline()
    local branch_name = GetCurrentBranch()
    local current_path = vim.fn.expand("%:p:h")
    local file_name = vim.fn.expand("%:t")

    local status_line = current_path .. "/" .. file_name
    if branch_name ~= "" then
        status_line = status_line .. " [" .. branch_name .. "]"
    end

    vim.o.statusline = status_line
end

vim.api.nvim_create_autocmd({"BufEnter", "BufWritePost", "FocusGained"}, {
    pattern = "*",
    callback = function()
        vim.cmd("silent! lcd %:p:h")
        SetStatusline()
    end
})

-- Initial call to set the statusline when Neovim starts
SetStatusline()


-- Function to get Git branch using Vim-fugitive
function GetGitBranch()
    local branch = vim.fn.FugitiveHead()
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

vim.opt.completeopt = { "menuone", "noselect", "noinsert" }

vim.cmd([[ set wildmode=longest:full ]])
