local M = {}

-- Configure compilation based on filetype
M.compile_commands = {
    c = "gcc -o %< %",
    sh = "shellcheck -f gcc %",
    go = "go build %",
}

-- Setup compilation for the current buffer
function M.setup_compile()
    local ft = vim.bo.filetype
    local compile_cmd = M.compile_commands[ft]

    if compile_cmd then
        vim.o.makeprg = compile_cmd
    end
end

-- Run make and open quickfix if there are errors
function M.compile()
    vim.cmd('write')  -- Save before compiling
    vim.cmd('make')

    -- Get quickfix list
    local qf_list = vim.fn.getqflist()
    if #qf_list > 0 then
        vim.cmd('copen')
    end
end

-- Set up keymaps
vim.keymap.set('n', '<C-x>cl', M.compile, { silent = true })

-- Auto setup compile command when opening supported files
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"c", "cpp", "rust", "go", "sh"},
    callback = M.setup_compile
})

return M
