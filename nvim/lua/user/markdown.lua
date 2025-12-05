-- vim.g.bullets_set_mappings = 0  -- Disable default mappings
--
-- -- Then set up your own mappings
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "markdown", "text" },
--   callback = function()
--     -- Normal Enter: just new line (like M-RET in org-mode)
--     vim.keymap.set('i', '<CR>', '<CR>', { buffer = true })
--
--     -- Alt-Enter or Ctrl-Enter: create new bullet
--     vim.keymap.set('i', '<M-CR>', '<Plug>(bullets-newline)', { buffer = true })
--     -- Or use Ctrl-Enter if you prefer:
--     -- vim.keymap.set('i', '<C-CR>', '<Plug>(bullets-newline)', { buffer = true })
--   end,
-- })
--
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "markdown", "text" },
--   callback = function()
--     vim.keymap.set({'n', 'v'}, '<C-c><C-c>', '<Plug>(bullets-toggle-checkbox)', { buffer = true })
--   end,
-- })

local group = vim.api.nvim_create_augroup("MarkdownSmartEnter", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    group = group,
    callback = function()
        -- Helper function: Returns the length of the list prefix (if any), or nil
        local function get_list_indent()
            local line = vim.api.nvim_get_current_line()
            -- 1. Check for bullet (- * +)
            local _, end_idx = string.find(line, "^%s*[-*+]%s+")
            -- 2. Check for number (1. 10.)
            if not end_idx then
                _, end_idx = string.find(line, "^%s*%d+%.%s+")
            end
            return end_idx
        end

        -- 1. INSERT MODE <CR>
        vim.keymap.set("i", "<CR>", function()
            local cr = vim.api.nvim_replace_termcodes("<CR>", true, true, true)
            local end_idx = get_list_indent()

            if end_idx then
                return cr .. string.rep(" ", end_idx)
            else
                return cr
            end
        end, { buffer = true, expr = true })

        -- 2. NORMAL MODE 'o'
        vim.keymap.set("n", "o", function()
            local end_idx = get_list_indent()

            if end_idx then
                -- Return "o" (to open line) + calculated spaces
                return "o" .. string.rep(" ", end_idx)
            else
                -- Return standard "o"
                return "o"
            end
        end, { buffer = true, expr = true })
    end,
})

vim.keymap.set("n", "<Leader>ll", function()
    local filepath = vim.fn.expand("%")
    vim.cmd("silent !markdownlint --fix " .. filepath)
    vim.cmd("e!")
    print("Markdown list fixed.")
end)

vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    group = group,
    callback = function()
        vim.keymap.set("i", "<M-CR>", function()
            local cr = vim.api.nvim_replace_termcodes("<CR>", true, true, true)

            -- Helper: Tries to match a line to a list pattern and returns the prefix for the NEW line.
            -- Returns nil if no match found.
            local function get_continuation_prefix(line)
                -- 1. Checkbox: "- [ ]", "* [x]", "+ [ ]"
                -- Captures indentation + bullet. Always returns empty box "[ ]"
                local indent, bullet = line:match("^(%s*)([-*+])%s+%[[x ]%]")
                if indent then
                    return indent .. bullet .. " [ ] "
                end

                -- 2. Bullet: "-", "*", "+"
                indent, bullet = line:match("^(%s*)([-*+])%s+")
                if indent then
                    return indent .. bullet .. " "
                end

                -- 3. Number: "1.", "10."
                -- Captures indent + number. Returns incremented number.
                local num
                indent, num = line:match("^(%s*)(%d+)%.%s+")
                if indent then
                    return indent .. (tonumber(num) + 1) .. ". "
                end

                return nil
            end

            -- STEP 1: Check Current Line
            local current_line = vim.api.nvim_get_current_line()
            local prefix = get_continuation_prefix(current_line)

            if prefix then
                return cr .. prefix
            end

            -- STEP 2: Search Upwards
            -- Get all lines up to the current cursor position
            local current_row = vim.api.nvim_win_get_cursor(0)[1] - 1
            local lines = vim.api.nvim_buf_get_lines(0, 0, current_row, false)

            local consecutive_empty_lines = 0

            -- Iterate backwards from the line above the cursor
            for i = #lines, 1, -1 do
                local line = lines[i]

                -- Stop conditions
                if line:match("^%s*$") then
                    consecutive_empty_lines = consecutive_empty_lines + 1
                    if consecutive_empty_lines >= 2 then break end
                elseif line:match("^#") then
                    -- Stop at header
                    break
                else
                    -- Not empty, reset empty counter
                    consecutive_empty_lines = 0

                    -- Check if this previous line is a list item
                    prefix = get_continuation_prefix(line)
                    if prefix then
                        return cr .. prefix
                    end

                    -- If it was text (not a list), the loop continues up
                end
            end

            -- If nothing found, just return normal Enter
            return cr
        end, { buffer = true, expr = true })
    end,
})
