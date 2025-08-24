local cached_branch = ""
local function update_branch()
    local handle = io.popen("git -C " .. vim.fn.expand('%:p:h') .. " rev-parse --abbrev-ref HEAD 2>/dev/null")
    if handle then
        local result = handle:read("*l")
        handle:close()
        if result and result ~= "" and result ~= "HEAD" then
            cached_branch = "[" .. result .. "]"
            return
        end
    end
    cached_branch = ""
end

-- public function for statusline
function _G.git_branch()
    return cached_branch
end

-- update when entering a buffer or changing directory
vim.api.nvim_create_autocmd({ "BufEnter", "DirChanged" }, {
    callback = update_branch,
})

-- Define a very minimal statusline
vim.o.statusline = table.concat({
  "%<%f",        -- file path
  " %m",         -- modified flag ("+" if unsaved, "-" if readonly)
  " %{v:lua.git_branch()}" -- branch in [brackets]
}, "")
