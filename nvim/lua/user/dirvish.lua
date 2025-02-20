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

  vim.api.nvim_echo({{"Delete " .. fname .. "? (y/n) "}}, false, {})
  local key = vim.fn.nr2char(vim.fn.getchar())
  if key:lower() ~= "y" then
    vim.notify("Aborted.", vim.log.levels.INFO)
    return
  end

  local ok, err = os.remove(fname)
  if not ok then
    vim.notify("Error deleting file: " .. err, vim.log.levels.ERROR)
    return
  end

  if vim.bo.filetype ~= "dirvish" then
    vim.cmd("bdelete!")
  else
    refresh_dirvish()  -- Use the helper function we defined earlier
  end
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
        local new_file = dir .. '/' .. input

        -- Create parent directories if needed
        local parent_dir = vim.fn.fnamemodify(new_file, ':h')
        if vim.fn.isdirectory(parent_dir) ~= 1 then
          vim.fn.mkdir(parent_dir, 'p')
        end

        -- Create empty file
        local f = io.open(new_file, 'w')
        if f then
          f:close()
          -- Refresh Dirvish while preserving cursor position
          local view = vim.fn.winsaveview()
          vim.cmd('edit')
          vim.fn.winrestview(view)
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
local function setup_rename()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'dirvish',
    callback = function()
      vim.keymap.set('n', 'R', function()
        local old_path = get_target_file()
        if not old_path then return end

        vim.ui.input({
          prompt = 'Rename to: ',
          default = vim.fn.fnamemodify(old_path, ':t')
        }, function(new_name)
          if not new_name or new_name == '' then return end

          local new_path = vim.fn.fnamemodify(old_path, ':h') .. '/' .. new_name
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

-- Initialize all commands --
-----------------------------
setup_create_dir()
setup_rename()
setup_permissions()
