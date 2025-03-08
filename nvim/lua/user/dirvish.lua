-- Override Dirvish's directory handling to avoid following symlinks
local function prevent_symlink_follow()
  -- Check if current buffer is a dirvish buffer
  if vim.b.dirvish then
    -- Make sure we're using the actual path, not the resolved one
    local path = vim.fn.fnamemodify(vim.fn.bufname('%'), ':p')
    -- Only if the path is a symlink
    if vim.fn.getftype(path) == 'link' then
      -- Force dirvish to use the symlink path itself, not what it points to
      vim.cmd('file ' .. vim.fn.fnameescape(path))
    end
  end
end

-- Create the autocommand group
vim.api.nvim_create_augroup('DirvishSymlinkFix', { clear = true })

-- Add the autocommand
vim.api.nvim_create_autocmd('BufEnter', {
  group = 'DirvishSymlinkFix',
  callback = prevent_symlink_follow
})

-- Function to add symlink indicators
local function add_symlink_indicators()
  -- Get buffer number for later use
  local bufnr = vim.api.nvim_get_current_buf()

  -- Define the highlight group if it doesn't exist
  vim.cmd('highlight default link DirvishSymlink Special')

  -- Process the buffer to mark symlinks
  local lines = vim.fn.getline(1, '$')
  local ns_id = vim.api.nvim_create_namespace('dirvish_symlinks')

  -- Clear existing virtual text
  vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)

  for i, line in ipairs(lines) do
    -- Remove trailing slash for symlink detection
    local path_to_check = line:gsub("/$", "")

    -- Get stats for the file/directory
    local stat = vim.loop.fs_lstat(path_to_check)

    -- Check if it's a symlink
    if stat and stat.type == "link" then
      -- Get the target of the symlink
      local target = vim.fn.fnamemodify(vim.fn.resolve(path_to_check), ":~")

      -- Add virtual text at the end of the line to show the symlink target
      vim.api.nvim_buf_set_virtual_text(
        bufnr,
        ns_id,
        i-1,  -- 0-indexed line number for API
        {{ " -> " .. target, "DirvishSymlink" }},
        {}
      )
    end
  end
end

-- Create autocmd group for dirvish symlinks
local dirvish_symlinks_group = vim.api.nvim_create_augroup("DirvishSymlinks", { clear = true })

-- FileType autocmd to set up symlink indicators when first entering a dirvish buffer
vim.api.nvim_create_autocmd("FileType", {
  group = dirvish_symlinks_group,
  pattern = "dirvish",
  callback = function()
    -- Wait a bit to ensure the dirvish buffer is fully populated
    vim.defer_fn(add_symlink_indicators, 10)
  end
})

-- BufEnter autocmd to refresh symlink indicators when returning to a dirvish buffer
vim.api.nvim_create_autocmd("BufEnter", {
  group = dirvish_symlinks_group,
  callback = function()
    -- Only process dirvish buffers
    if vim.bo.filetype == "dirvish" then
      -- Wait a bit to ensure the dirvish buffer is fully populated
      vim.defer_fn(add_symlink_indicators, 10)
    end
  end
})


-- Remove the global mapping (if it's already set)
vim.api.nvim_del_keymap('n', '-')
-- vim.api.nvim_del_keymap('n', 'S')

-- Set a buffer-local mapping for Dirvish buffers
vim.api.nvim_create_autocmd("FileType", {
  pattern = "dirvish",
  callback = function()
    vim.api.nvim_buf_set_keymap(0, 'n', '-', '<Plug>(dirvish_up)', { noremap = false, silent = true })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "dirvish",
  callback = function()
    vim.api.nvim_set_hl(0, "CursorLineNr", { link = "LineNr" })
    -- This makes the current line number look the same as other line numbers
  end,
})

-- local function get_target_file()
--   if vim.bo.filetype == "dirvish" then
--     local current_dir = vim.fn.expand('%:p')
--     if vim.fn.isdirectory(current_dir) ~= 1 then
--       current_dir = vim.fn.fnamemodify(current_dir, ":h")
--     end
--     current_dir = current_dir:gsub("[/\\]$", "")
--     local item = vim.fn.expand("<cfile>")
--     if item == "" then
--       vim.notify("No file under cursor", vim.log.levels.ERROR)
--       return nil
--     end
--     if item:sub(1,1) == "/" or item:match("^[A-Za-z]:[/\\]") then
--       return item
--     else
--       return current_dir .. "/" .. item
--     end
--   else
--     return vim.api.nvim_buf_get_name(0)
--   end
-- end

-- Shared helper functions --
local function refresh_dirvish()
  local view = vim.fn.winsaveview()
  vim.cmd('edit')
  vim.fn.winrestview(view)
end

local function get_current_dir()
  if vim.bo.filetype == "dirvish" then
    local dir = vim.fn.expand('%:p')
    return vim.fn.isdirectory(dir) == 1 and dir:gsub("[/\\]$", "") or vim.fn.fnamemodify(dir, ":h")
  end
  return vim.fn.expand('%:p:h')
end

local function get_target_file()
  if vim.bo.filetype == "dirvish" then
    local item = vim.fn.expand("<cfile>")
    if item == "" then return nil end
    return item:match("^[/\\]") and item or get_current_dir() .. "/" .. item
  end
  return vim.api.nvim_buf_get_name(0)
end


local function DeleteFile()
  local fname = get_target_file()
  if not fname or fname == "" then
    vim.notify("No file associated with this item.", vim.log.levels.ERROR)
    return
  end

  -- If fname ends with a slash, check if the path without the slash is a symlink.
  if fname:sub(-1) == "/" then
    local testname = fname:sub(1, -2)
    local lstat = vim.loop.fs_lstat(testname)
    if lstat and lstat.type == "link" then
      vim.notify("DEBUG: Removing trailing slash from symlink", vim.log.levels.DEBUG)
      fname = testname
    end
  end

  vim.api.nvim_echo({{"Delete " .. fname .. "? (y/n) "}}, false, {})
  local key = vim.fn.nr2char(vim.fn.getchar())
  if key:lower() ~= "y" then
    vim.notify("Aborted.", vim.log.levels.INFO)
    return
  end

  local cmd = "rm -rf '" .. fname:gsub("'", "'\\''") .. "'"
  vim.notify("DEBUG: Executing: " .. cmd, vim.log.levels.DEBUG)
  local exit_code = os.execute(cmd)
  vim.notify("DEBUG: Command exit code: " .. tostring(exit_code), vim.log.levels.DEBUG)
  if exit_code ~= 0 then
    vim.notify("Error deleting " .. fname, vim.log.levels.ERROR)
    return
  end

  -- Iterate over all buffers and delete any that match the file name.
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(bufnr) == fname then
      vim.cmd("bdelete! " .. bufnr)
    end
  end

  if vim.bo.filetype == "dirvish" then
    refresh_dirvish()
  end

  vim.notify("Deleted " .. fname, vim.log.levels.INFO)
end


-- Create global command
vim.api.nvim_create_user_command("Delete", DeleteFile, {})

-- Set keybinding only in dirvish buffers
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'dirvish',
  callback = function()
    vim.keymap.set('n', 'D', DeleteFile, { buffer = true, desc = "Delete file" })
  end
})


-- Netrw-style % command for creating files in Dirvish
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'dirvish',
  callback = function()
    vim.keymap.set('n', '%', function()
      local dir = vim.fn.expand('%:p')
      if vim.fn.isdirectory(dir) ~= 1 then
        dir = vim.fn.fnamemodify(dir, ':h')
      end
      vim.ui.input({prompt = 'New file: ', completion = 'file'}, function(input)
        if not input or input == '' then return end
        -- Use vim.fs.normalize to handle path concatenation properly
        local new_file = vim.fs.normalize(dir .. '/' .. input)
        -- Create parent directories if needed
        local parent_dir = vim.fn.fnamemodify(new_file, ':h')
        if vim.fn.isdirectory(parent_dir) ~= 1 then
          vim.fn.mkdir(parent_dir, 'p')
        end
        -- Create empty file
        local f = io.open(new_file, 'w')
        if f then
          f:close()
          -- Edit the newly created file
          vim.cmd('edit ' .. vim.fn.fnameescape(new_file))
        else
          vim.notify('Failed to create file: ' .. new_file, vim.log.levels.ERROR)
        end
      end)
    end, {buffer = true})
  end
})


-- Directory creation command (d mapping) --
-------------------------------------------
local function setup_create_dir()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'dirvish',
    callback = function()
      vim.keymap.set('n', '+', function()
        local dir = get_current_dir()
        vim.ui.input({prompt = 'New directory: '}, function(input)
          if not input or input == '' then return end
          local new_dir = dir .. '/' .. input

          if vim.fn.mkdir(new_dir, 'p') == 1 then
            refresh_dirvish()
          else
            vim.notify('Failed to create directory: ' .. new_dir, vim.log.levels.ERROR)
          end
        end)
      end, {buffer = true})
    end
  })
end

-- Rename command (R mapping) --
---------------------------------
-- local function setup_rename()
--   vim.api.nvim_create_autocmd('FileType', {
--     pattern = 'dirvish',
--     callback = function()
--       vim.keymap.set('n', 'R', function()
--         local old_path = get_target_file()
--         if not old_path then return end
--
--         vim.ui.input({
--           prompt = 'Rename to: ',
--           default = vim.fn.fnamemodify(old_path, ':t')
--         }, function(new_name)
--           if not new_name or new_name == '' then return end
--
--           local new_path = vim.fn.fnamemodify(old_path, ':h') .. '/' .. new_name
--           local ok, err = os.rename(old_path, new_path)
--           if ok then
--             refresh_dirvish()
--             vim.notify('Renamed to: ' .. new_path, vim.log.levels.INFO)
--           else
--             vim.notify('Rename failed: ' .. err, vim.log.levels.ERROR)
--           end
--         end)
--       end, {buffer = true})
--     end
--   })
-- end

local function setup_rename()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'dirvish',
    callback = function()
      vim.keymap.set('n', 'R', function()
        local old_path = get_target_file()
        if not old_path then return end

        vim.ui.input({
          prompt = 'Rename to: ',
          default = old_path
        }, function(new_name)
          if not new_name or new_name == '' then return end

          local new_path
          -- If the new_name starts with '/', assume it's an absolute path (move/rename anywhere)
          if new_name:sub(1,1) == '/' then
            new_path = new_name
          else
            new_path = vim.fn.fnamemodify(old_path, ':h') .. '/' .. new_name
          end

          local ok, err = os.rename(old_path, new_path)
          if ok then
            refresh_dirvish()
            vim.notify('Renamed to: ' .. new_path, vim.log.levels.INFO)
          else
            vim.notify('Rename failed: ' .. err, vim.log.levels.ERROR)
          end
        end)
      end, {buffer = true})
    end
  })
end

-- Permissions command (M mapping) --
-------------------------------------
local function setup_permissions()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'dirvish',
    callback = function()
      vim.keymap.set('n', 'M', function()
        local path = get_target_file()
        if not path then return end

        vim.ui.input({
          prompt = 'New permissions (octal): ',
          default = string.format('%o', vim.fn.getfperm(path):sub(1, 9))
        }, function(input)
          if not input or input == '' then return end

          if not input:match('^%d%d%d$') then
            vim.notify('Invalid octal format. Use 3 digits (e.g., 755)', vim.log.levels.ERROR)
            return
          end

          local cmd = string.format("chmod %s '%s'", input, path:gsub("'", "'\\''"))
          local exit_code = os.execute(cmd)

          if exit_code == 0 then
            refresh_dirvish()
            vim.notify('Permissions updated to ' .. input, vim.log.levels.INFO)
          else
            vim.notify('Failed to change permissions', vim.log.levels.ERROR)
          end
        end)
      end, {buffer = true})
    end
  })
end


-- Helper: Find another dirvish window in the current tab that’s showing a different path
local function find_other_dirvish_window()
  local current_win = vim.api.nvim_get_current_win()
  local current_buf = vim.api.nvim_get_current_buf()
  local current_path = vim.api.nvim_buf_get_name(current_buf)
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if win ~= current_win then
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.api.nvim_buf_get_option(buf, 'filetype') == 'dirvish' then
        local other_path = vim.api.nvim_buf_get_name(buf)
        if other_path ~= current_path then
          return other_path
        end
      end
    end
  end
  return nil
end

-- Setup copy command (C binding)
local function setup_copy()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'dirvish',
    callback = function()
      vim.keymap.set('n', 'C', function()
        local source = get_target_file()
        if not source then return end

        -- Try to find another dirvish window and build a default target path:
        local other_dir = find_other_dirvish_window()
        local default_target = source
        if other_dir then
          default_target = other_dir .. '/' .. vim.fn.fnamemodify(source, ':t')
        end

        vim.ui.input({
          prompt = 'Copy to: ',
          default = default_target
        }, function(input)
          if not input or input == '' then return end

          local cmd = string.format("cp -r '%s' '%s'", source, input)
          local exit_code = os.execute(cmd)
          if exit_code == 0 then
            refresh_dirvish()
            vim.notify('Copied to: ' .. input, vim.log.levels.INFO)
          else
            vim.notify('Copy failed', vim.log.levels.ERROR)
          end
        end)
      end, {buffer = true})
    end
  })
end

local function setup_symlink()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'dirvish',
    callback = function()
      vim.keymap.set('n', 'S', function()
        local source = get_target_file()
        if not source then return end

        -- Use the helper to try finding another dirvish window's directory:
        local other_dir = find_other_dirvish_window()
        local default_target = source
        if other_dir then
          default_target = other_dir .. '/' .. vim.fn.fnamemodify(source, ':t')
        end

        vim.ui.input({
          prompt = 'Symlink to: ',
          default = default_target
        }, function(input)
          if not input or input == '' then return end

          local cmd = string.format("ln -s '%s' '%s'", source, input)
          local exit_code = os.execute(cmd)
          if exit_code == 0 then
            refresh_dirvish()
            vim.notify('Symlink created: ' .. input, vim.log.levels.INFO)
          else
            vim.notify('Symlink creation failed', vim.log.levels.ERROR)
          end
        end)
      end, {buffer = true})
    end
  })
end


-- Initialize all commands
setup_create_dir()
setup_rename()
setup_permissions()
setup_copy()
setup_symlink()


vim.keymap.set("n", "<leader>fe", function()
  local fname = vim.api.nvim_buf_get_name(0)
  if fname == "" then
    -- no file name, so open Dirvish on the cwd
    return vim.cmd("Dirvish")
  end

  local target = fname
  if vim.fn.isdirectory(fname) ~= 1 then
    local head = vim.fn.fnamemodify(fname, ":h")
    if vim.fn.isdirectory(head) == 1 then
      target = head
    else
      target = nil
    end
  end

  if target then
    vim.cmd("Dirvish " .. target)
  else
    -- fallback: open Dirvish on the current working directory
    vim.cmd("Dirvish")
  end
end)
