local M = {}
local jumping = false

-- Tables to store history and index by window ID.
local history_by_win = {}
local index_by_win = {}

-- Get (or initialize) the history and index for the given window.
local function get_history(win)
  if not history_by_win[win] then
    history_by_win[win] = {}
    index_by_win[win] = 0
  end
  return history_by_win[win], index_by_win[win]
end

-- Helper function to get a stable identifier for netrw and oil.nvim buffers
local function get_buffer_identifier(bufnr)
  local ft = vim.bo[bufnr].filetype
  local name = vim.fn.bufname(bufnr)

  if ft == "netrw" then
    return "netrw:" .. vim.fn.fnamemodify(name, ":p")
  elseif ft == "oil" then
    return "oil:" .. vim.fn.fnamemodify(name, ":p")
  elseif ft == "dirvish" then
    return "dirvish:" .. vim.fn.fnamemodify(name, ":p")
  else
    return bufnr
  end
end

-- Add a buffer (by number) to the history for the current window.
function M.add(bufnr)
  local win = vim.api.nvim_get_current_win()
  local hist, cur_index = get_history(win)

  if jumping then
    return
  end

  local identifier = get_buffer_identifier(bufnr)

  if cur_index < #hist then
    for i = #hist, cur_index + 1, -1 do
      table.remove(hist, i)
    end
  end

  if cur_index > 0 and hist[cur_index] == identifier then
    return
  end

  local found_index = nil
  for i, b in ipairs(hist) do
    if b == identifier then
      found_index = i
      break
    end
  end

  if found_index then
    table.remove(hist, found_index)
    if found_index <= cur_index then
      cur_index = cur_index - 1
    end
  end

  table.insert(hist, identifier)
  cur_index = #hist
  index_by_win[win] = cur_index
end

-- Jump through the history.
function M.jump(dir, count)
  local win = vim.api.nvim_get_current_win()
  local hist, cur_index = get_history(win)
  dir = dir or -1
  count = count or 1

  local new_index = cur_index + (dir * count)

  if new_index < 1 or new_index > #hist then
    vim.notify(dir > 0 and "Reached end of buffer history" or "Reached start of buffer history", vim.log.levels.INFO)
    return
  end

  local target = hist[new_index]

  if type(target) == "string" then
    if target:match("^netrw:") then
      local path = target:gsub("^netrw:", "")
      index_by_win[win] = new_index
      jumping = true
      vim.cmd("Explore " .. vim.fn.fnameescape(path))
      jumping = false
      return
    elseif target:match("^oil:") then
      local path = target:gsub("^oil:", "")
      index_by_win[win] = new_index
      jumping = true
      require("oil").open(path)
      jumping = false
      return
    end
  end

  if vim.fn.bufexists(target) == 1 then
    index_by_win[win] = new_index
    jumping = true
    vim.cmd("buffer " .. target)
    jumping = false
    return
  else
    M.remove(target)
    M.jump(dir, 1)
  end
end

-- Remove a buffer from the history.
function M.remove(identifier)
  local win = vim.api.nvim_get_current_win()
  local hist, cur_index = get_history(win)

  if identifier == -1 then
    history_by_win[win] = {}
    index_by_win[win] = 0
    return
  end

  local new_history = {}
  for i, b in ipairs(hist) do
    if b ~= identifier then
      table.insert(new_history, b)
    end
  end

  history_by_win[win] = new_history
  if index_by_win[win] > #new_history then
    index_by_win[win] = #new_history
  end
end

return M
