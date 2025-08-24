local function update_branch(bufnr)
    local path = vim.api.nvim_buf_get_name(bufnr)
    if path == "" then return end
    local dir = vim.fn.fnamemodify(path, ":h")
    local handle = io.popen("git -C " .. dir .. " rev-parse --abbrev-ref HEAD 2>/dev/null")
    if handle then
        local result = handle:read("*l")
        handle:close()
        if result and result ~= "" and result ~= "HEAD" then
            vim.b[bufnr].git_branch = "[" .. result .. "]"
            return
        end
    end
    vim.b[bufnr].git_branch = ""
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
    callback = function(args) update_branch(args.buf) end,
})

function _G.git_branch()
    return vim.b.git_branch or ""
end

-- Define a very minimal statusline
vim.o.statusline = table.concat({
  "%<%f",        -- file path
  " %m",         -- modified flag ("+" if unsaved, "-" if readonly)
  " %{v:lua.git_branch()}" -- branch in [brackets]
}, "")
