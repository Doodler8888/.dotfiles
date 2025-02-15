local M = {}
local jumping = false
local debug_enabled = true

-- Tables to store history and index by window ID.
local history_by_win = {}
local index_by_win = {}

local function dbg(msg)
  if debug_enabled then
    vim.notify("[BufferHistory DEBUG] " .. msg, vim.log.levels.DEBUG)
  end
end

-- Get (or initialize) the history and index for the given window.
local function get_history(win)
  if not history_by_win[win] then
    history_by_win[win] = {}
    index_by_win[win] = 0
    dbg("Initialized history for window " .. win)
  end
  return history_by_win[win], index_by_win[win]
end

-- Helper function to get a stable identifier for netrw buffers
local function get_buffer_identifier(bufnr)
  local ft = vim.bo[bufnr].filetype
  local name = vim.fn.bufname(bufnr)

  if ft == "netrw" then
    -- For netrw, use the full path as identifier
    return "netrw:" .. vim.fn.fnamemodify(name, ":p")
  else
    -- For regular buffers, use the buffer number
    return bufnr
  end
end

-- Add a buffer (by number) to the history for the current window.
function M.add(bufnr)
  local win = vim.api.nvim_get_current_win()
  local hist, cur_index = get_history(win)

  if jumping then
    dbg("Skipping add in window " .. win .. " because we're in a jump.")
    return
  end

  local ft = vim.bo[bufnr].filetype
  local name = vim.fn.bufname(bufnr)
  local bufinfo = vim.fn.getbufinfo(bufnr)[1]
  local identifier = get_buffer_identifier(bufnr)

  dbg(string.format("ADD: win=%s buf=%s ft=%s idx=%s/%s jump=%s",
    win, identifier, ft, cur_index, #hist, jumping))

  -- If we're not at the end of the history, truncate any "forward" history.
  if cur_index < #hist then
    for i = #hist, cur_index + 1, -1 do
      table.remove(hist, i)
    end
  end

  -- If the current history already has this buffer as current, do nothing.
  if cur_index > 0 and hist[cur_index] == identifier then
    return
  end

  -- If the buffer is already somewhere in the history, remove it.
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

  -- Append the new buffer to the history.
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

  dbg(string.format("JUMP: win=%s dir=%s cur=%s new=%s/%s",
    win, dir, cur_index, new_index, #hist))

  if new_index < 1 or new_index > #hist then
    vim.notify(dir > 0 and "Reached end of buffer history" or "Reached start of buffer history",
      vim.log.levels.INFO)
    return
  end

  local target = hist[new_index]

  -- Handle jumping to netrw buffers
  if type(target) == "string" and target:match("^netrw:") then
    local path = target:gsub("^netrw:", "")
    index_by_win[win] = new_index
    jumping = true
    dbg(string.format("NETRW JUMP: path=%s idx=%s", path, new_index))
    vim.cmd("Explore " .. vim.fn.fnameescape(path))
    jumping = false
    return
  end

  -- Handle regular buffers
  if vim.fn.bufexists(target) == 1 then
    index_by_win[win] = new_index
    jumping = true
    vim.cmd("buffer " .. target)
    jumping = false
    return
  else
    dbg("Target buffer " .. tostring(target) .. " does not exist, removing")
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
