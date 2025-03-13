-- -- This is a more sophisticated version
-- local M = {}
--
-- -- Helper to produce a stable identifier for special filetypes.
-- local function get_buffer_identifier(bufnr)
--   local ft = vim.bo[bufnr].filetype
--   local name = vim.fn.bufname(bufnr)
--
--   if ft == "netrw" then
--     return "netrw:" .. vim.fn.fnamemodify(name, ":p")
--   elseif ft == "oil" then
--     return "oil:" .. vim.fn.fnamemodify(name, ":p")
--   elseif ft == "dirvish" then
--     return "dirvish:" .. vim.fn.fnamemodify(name, ":p")
--   else
--     return bufnr
--   end
-- end
--
-- -- Get a sorted list of buffers by last used time (most recent first)
-- local function get_sorted_buffers()
--   local bufs = vim.fn.getbufinfo({ buflisted = 1 })
--   table.sort(bufs, function(a, b)
--     -- lastused is a timestamp; sort in descending order
--     return a.lastused > b.lastused
--   end)
--   return bufs
-- end
--
-- -- Jump through buffers using the built-in history ordering.
-- -- dir: -1 for older buffers (jump "back" in history), 1 for newer.
-- -- count: number of positions to move.
-- function M.jump(dir, count)
--   dir = dir or -1
--   count = count or 1
--
--   local bufs = get_sorted_buffers()
--   local cur_buf = vim.api.nvim_get_current_buf()
--   local cur_index = nil
--
--   -- Find the current buffer's position in the sorted list.
--   for i, buf in ipairs(bufs) do
--     if buf.bufnr == cur_buf then
--       cur_index = i
--       break
--     end
--   end
--
--   if not cur_index then
--     vim.notify("Current buffer not found in history", vim.log.levels.ERROR)
--     return
--   end
--
--   local new_index = cur_index + (dir * count)
--   if new_index < 1 or new_index > #bufs then
--     vim.notify(dir > 0 and "Reached end of buffer history" or "Reached start of buffer history", vim.log.levels.INFO)
--     return
--   end
--
--   local target_buf = bufs[new_index]
--   local identifier = get_buffer_identifier(target_buf.bufnr)
--
--   -- Handle special filetypes.
--   if type(identifier) == "string" then
--     if identifier:match("^netrw:") then
--       local path = identifier:gsub("^netrw:", "")
--       vim.cmd("Explore " .. vim.fn.fnameescape(path))
--       return
--     elseif identifier:match("^oil:") then
--       local path = identifier:gsub("^oil:", "")
--       require("oil").open(path)
--       return
--     end
--   end
--
--   -- Verify that the target buffer exists before switching.
--   if vim.fn.bufexists(target_buf.bufnr) == 1 then
--     vim.cmd("buffer " .. target_buf.bufnr)
--   else
--     vim.notify("Target buffer does not exist", vim.log.levels.ERROR)
--   end
-- end
--
-- return M


-- -- This is the version that parses 'ls t' output:
-- local M = {}
--
-- -- Get all listed and loaded buffers, then sort them by last used (most recent first)
-- local function get_sorted_buffers()
--   local bufs = vim.fn.getbufinfo({bufloaded = 1, buflisted = 1})
--   table.sort(bufs, function(a, b)
--     return a.lastused > b.lastused
--   end)
--   return bufs
-- end
--
-- -- Jump through buffer history.
-- -- 'dir' should be -1 (to go back/older) or 1 (to go forward/newer)
-- -- 'count' is optional and defaults to 1.
-- function M.jump(dir, count)
--   count = count or 1
--   local current = vim.api.nvim_get_current_buf()
--   local sorted = get_sorted_buffers()
--
--   local idx = nil
--   for i, buf in ipairs(sorted) do
--     if buf.bufnr == current then
--       idx = i
--       break
--     end
--   end
--
--   if not idx then
--     vim.notify("Current buffer not found in history", vim.log.levels.ERROR)
--     return
--   end
--
--   local new_idx = idx + (dir * count)
--   if new_idx < 1 or new_idx > #sorted then
--     vim.notify("No more buffers in that direction", vim.log.levels.INFO)
--     return
--   end
--
--   local target_buf = sorted[new_idx].bufnr
--
--   -- Optional: special handling for buffers like netrw, oil, or dirvish.
--   local ft = vim.api.nvim_buf_get_option(target_buf, "filetype")
--   local name = vim.fn.bufname(target_buf)
--   if ft == "netrw" then
--     local path = vim.fn.fnamemodify(name, ":p")
--     vim.cmd("Explore " .. vim.fn.fnameescape(path))
--   elseif ft == "oil" then
--     local path = vim.fn.fnamemodify(name, ":p")
--     require("oil").open(path)
--   else
--     vim.cmd("buffer " .. target_buf)
--   end
-- end
--
-- return M


-- This is the original version
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
