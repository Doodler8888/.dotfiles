require("user")


vim.api.nvim_create_autocmd("CmdlineEnter", {
  pattern = "*",
  callback = function()
    vim.api.nvim_create_autocmd("CmdlineLeave", {
      pattern = "*",
      once = true,
      callback = function()
        local cmd = vim.fn.getcmdline()
        if cmd == "so" or cmd:match("^so ") then
          vim.cmd("wall")
          print("All buffers saved before sourcing")
        end
      end
    })
  end
})


-- Function to remove trailing whitespaces
local function remove_trailing_whitespace()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
end

-- Autocmd to remove trailing whitespaces after paste
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("RemoveTrailingWhitespace", { clear = true }),
    callback = function()
        vim.schedule(function()
            -- Check if the last operation was a paste
            if vim.v.event.operator == "p" or vim.v.event.operator == "P" then
                remove_trailing_whitespace()
            end
        end)
    end,
})
