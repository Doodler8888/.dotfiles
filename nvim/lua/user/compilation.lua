local M = {}

M.compile_commands = {
    c = "gcc -o %< % && ./%<",
    go = "go run %",
    sh = "./%",
    cpp = "g++ -o %< % && ./%<",
    rust = "cargo run",
}

function M.float_term(cmd)
    -- Create terminal buffer
    local buf = vim.api.nvim_create_buf(false, true)

    -- Calculate floating window dimensions (80% of main window)
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)

    -- Create floating window
    local win = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = width,
        height = height,
        col = (vim.o.columns - width) / 2,
        row = (vim.o.lines - height) / 2 - 1,  -- Center vertically
        style = 'minimal',
        border = 'rounded'
    })

    -- Run command in terminal
    vim.fn.termopen(cmd)
end

function M.compile()
    vim.cmd('write')  -- Save current file
    local cmd = vim.fn.expandcmd(vim.o.makeprg)
    M.float_term(cmd)
end

-- Setup filetype-specific commands
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"c", "cpp", "rust", "go", "sh"},
    callback = function()
        local ft = vim.bo.filetype
        vim.o.makeprg = M.compile_commands[ft]:gsub("%%", vim.fn.expand("%"))
    end
})

vim.keymap.set('n', '<F5>', M.compile, { silent = true })

return M
