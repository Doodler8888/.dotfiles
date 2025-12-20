local M = {}

-- single source of truth
M.sessions_dir = vim.fn.stdpath("cache") .. "/sessions"

-- ensure directory exists
if vim.fn.isdirectory(M.sessions_dir) == 0 then
  vim.fn.mkdir(M.sessions_dir, "p")
end

-- paths
function M.session_path(name)
  return M.sessions_dir .. "/" .. name
end

function M.tabnames_path(name)
  return M.session_path(name) .. ".tabnames"
end

function M.oil_path(name)
  return M.session_path(name) .. ".oil"
end

-- list sessions
function M.list()
  local files = vim.fn.split(vim.fn.globpath(M.sessions_dir, "*"), "\n")
  local sessions = {}

  for _, file in ipairs(files) do
    if file ~= ""
      and not file:match("%.tabnames$")
      and not file:match("%.oil$")
    then
      table.insert(sessions, vim.fn.fnamemodify(file, ":t"))
    end
  end

  return sessions
end

-- load
function M.load(name)
  if not name or name == "" then
    return
  end

  local path = M.session_path(name)
  if vim.fn.filereadable(path) == 1 then
    vim.g.current_session_name = name
    vim.g.session_loaded = true
    vim.cmd("source " .. vim.fn.fnameescape(path))
  else
    vim.notify("Session not found: " .. path, vim.log.levels.WARN)
  end
end

-- save
function M.save(name)
  name = name or vim.g.current_session_name
  if not name or name == "" then
    name = vim.fn.input("Session name: ")
    if name == "" then
      return
    end
  end

  local path = M.session_path(name)
  vim.cmd("mksession! " .. vim.fn.fnameescape(path))

  vim.g.current_session_name = name
  vim.g.session_loaded = true
end

-- delete
function M.delete(name)
  local path = M.session_path(name)
  if vim.fn.filereadable(path) ~= 1 then
    return
  end

  vim.fn.delete(path)
  vim.fn.delete(M.tabnames_path(name))
  vim.fn.delete(M.oil_path(name))

  if vim.g.current_session_name == name then
    vim.g.current_session_name = nil
    vim.g.session_loaded = false
  end
end

return M
