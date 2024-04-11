require("user")


-- Define the function to show highlight groups under the cursor
function ShowHighlightGroupUnderCursor()
    -- Get the current cursor position
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    -- Adjust for 0-indexing
    col = col + 1

    -- Get the syntax ID at the current position
    local synID = vim.fn.synID(row, col, true)
    -- Get the translated (effective) highlight ID from the syntax ID
    local hlID = vim.fn.synIDtrans(synID)
    -- Get the name of the highlight group
    local hlName = vim.fn.synIDattr(hlID, "name")

    -- Print the highlight group name
    print("Highlight Group: " .. hlName)
end

-- Optionally, create a command for easy access
vim.api.nvim_create_user_command('ShowHlGroup', ShowHighlightGroupUnderCursor, {})
