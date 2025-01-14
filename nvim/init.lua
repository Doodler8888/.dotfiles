require("user")


local last_window_state = nil
local last_buffers = {}

function _G.smart_qf_open()
    -- Debugging helper
    local function debug_print(msg, data)
        print(string.format("DEBUG - %s: %s", msg, vim.inspect(data)))
    end

    -- Save current window
    local current_win = vim.api.nvim_get_current_win()

    -- Check if quickfix is open
    local qf_win = nil
    for _, win in pairs(vim.fn.getwininfo()) do
        if win.quickfix == 1 then
            qf_win = win.winid
            break
        end
    end

    if qf_win then
        debug_print("Quickfix already open, closing", qf_win)

        -- Close quickfix
        vim.cmd("cclose")

        -- Restore window layout
        if last_window_state then
            debug_print("Restoring window layout", last_window_state)

            -- Restore the window layout
            vim.cmd(last_window_state)

            -- Reassociate buffers
            for win, buf in pairs(last_buffers) do
                if vim.api.nvim_win_is_valid(win) and vim.api.nvim_buf_is_valid(buf) then
                    vim.api.nvim_win_set_buf(win, buf)
                end
            end

            -- Clear saved state
            last_window_state = nil
            last_buffers = {}
        else
            debug_print("No saved layout to restore", nil)
        end

        -- Return to original window if still valid
        if vim.api.nvim_win_is_valid(current_win) then
            vim.api.nvim_set_current_win(current_win)
        end
    else
        debug_print("Opening quickfix", "")

        -- Save layout and buffers only if not already saved
        if not last_window_state then
            last_window_state = vim.fn.winrestcmd()
            debug_print("Saved window layout", last_window_state)

            -- Save current buffers in each window
            last_buffers = {}
            for _, win in pairs(vim.api.nvim_list_wins()) do
                last_buffers[win] = vim.api.nvim_win_get_buf(win)
            end
            debug_print("Saved buffers per window", last_buffers)
        else
            debug_print("Layout already saved, skipping", last_window_state)
        end

        -- Calculate quickfix width
        local qf_width = math.floor(vim.o.columns / 2)

        -- Get current window position
        local win_pos = vim.api.nvim_win_get_position(current_win)[2]

        -- Debug window position
        debug_print("Current window position", win_pos)

        -- Close all windows except the current one
        vim.cmd("only")
        debug_print("Closed all windows except current", "")

        -- Open quickfix based on window position
        if win_pos > 0 then
            vim.cmd("topleft vertical copen " .. qf_width)
            debug_print("Opened quickfix on the left", qf_width)
        else
            vim.cmd("vertical botright copen " .. qf_width)
            debug_print("Opened quickfix on the right", qf_width)
        end

        -- Return focus to the original window
        if vim.api.nvim_win_is_valid(current_win) then
            vim.api.nvim_set_current_win(current_win)
            debug_print("Restored focus to original window", current_win)
        end
    end
end

vim.api.nvim_create_user_command("SmartQF", smart_qf_open, {})
