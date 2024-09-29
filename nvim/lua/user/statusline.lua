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
