-- It uses trash cli, but i need to just move files.
function NetrwTrash()
  local line = vim.fn.getline('.')
  if not line or line == "" then
    print("No file selected!")
    return
  end

  local filepath = vim.fn.expand('%:p') .. line
  local trash_cmd = "trash " .. vim.fn.shellescape(filepath)

  local function get_user_input_char()
    local c = vim.fn.getchar()
    return vim.fn.nr2char(c)
  end

  print("Trash " .. filepath .. " ? (y/n)")

  if get_user_input_char():match('^y') then
    vim.fn.jobstart(trash_cmd, {
      detach = true,
      on_exit = function()
        print(filepath .. " moved to Trash.")
        vim.cmd("edit")
      end,
    })
  else
    print("Cancelled trash operation.")
  end
end
