-- Function to get current git branch, returns "[branch]" or "" if not in repo
function _G.git_branch()
  local handle = io.popen("git -C " .. vim.fn.expand('%:p:h') .. " rev-parse --abbrev-ref HEAD 2>/dev/null")
  if handle then
    local result = handle:read("*l")
    handle:close()
    if result and result ~= "" and result ~= "HEAD" then
      return "[" .. result .. "]"
    end
  end
  return ""
end

-- Define a very minimal statusline
vim.o.statusline = table.concat({
  "%<%f",        -- file path
  " %m",         -- modified flag ("+" if unsaved, "-" if readonly)
  " %{v:lua.git_branch()}" -- branch in [brackets]
}, "")
