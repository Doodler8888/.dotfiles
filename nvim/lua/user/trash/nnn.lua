local function open_nnn_float()
  -- Create a new scratch buffer for the terminal
  local buf = vim.api.nvim_create_buf(false, true)

  -- Calculate window dimensions (80% of the editor size)
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2 - 1)
  local col = math.floor((vim.o.columns - width) / 2)

  local opts = {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    border = "rounded",
  }

  -- Open the floating window
  local win = vim.api.nvim_open_win(buf, true, opts)

  -- Get the directory of the current buffer; fallback to the current working directory
  local cwd = vim.fn.expand('%:p:h')
  if cwd == "" then
    cwd = vim.fn.getcwd()
  end

  -- Open a terminal running nnn with an on_exit callback to close the float automatically.
  vim.fn.termopen("nnn", {
    cwd = cwd,
    on_exit = function(_, exit_code, _)
      -- Schedule the close to ensure it runs in the main event loop.
      vim.schedule(function()
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end
      end)
    end,
  })

  -- Enter insert mode to interact with the terminal immediately.
  vim.cmd("startinsert")
end

-- Create a Neovim command to easily launch the floating nnn window
vim.api.nvim_create_user_command("NnnFloat", open_nnn_float, {})
