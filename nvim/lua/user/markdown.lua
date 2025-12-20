vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    -- Set text width to 80 characters
    vim.opt_local.textwidth = 80

    -- Enable auto-wrapping
    vim.opt_local.formatoptions:append("t")

    -- Enable auto-wrapping comments using textwidth
    vim.opt_local.formatoptions:append("c")

    -- Remove comment leader when joining lines
    vim.opt_local.formatoptions:append("j")

    -- Don't break lines at single spaces that follow periods
    vim.opt_local.formatoptions:append("q")
  end
})

local group = vim.api.nvim_create_augroup("MarkdownSmartEnter", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    group = group,
    callback = function()
        -- 1. Standard Smart Enter (Insert Mode)
        vim.keymap.set("i", "<CR>", function()
            local line = vim.api.nvim_get_current_line()
            local _, end_idx = string.find(line, "^%s*[-*+]%s+")
            if not end_idx then
                _, end_idx = string.find(line, "^%s*%d+%.%s+")
            end

            local cr = vim.api.nvim_replace_termcodes("<CR>", true, true, true)
            if end_idx then
                return cr .. string.rep(" ", end_idx)
            else
                return cr
            end
        end, { buffer = true, expr = true })

        -- 2. Normal Mode 'o'
        vim.keymap.set("n", "o", function()
            local line = vim.api.nvim_get_current_line()
            local _, end_idx = string.find(line, "^%s*[-*+]%s+")
            if not end_idx then
                _, end_idx = string.find(line, "^%s*%d+%.%s+")
            end

            if end_idx then
                return "o" .. string.rep(" ", end_idx)
            else
                return "o"
            end
        end, { buffer = true, expr = true })

        -- 3. M-RET: Create new list item
        vim.keymap.set("i", "<M-CR>", function()
            local cr = vim.api.nvim_replace_termcodes("<CR>", true, true, true)
            local cu = vim.api.nvim_replace_termcodes("<C-u>", true, true, true)

            -- Helper to generate the next list marker (e.g. "2. ", "- [ ] ")
            local function prefix_from_line(l)
                -- Checkboxes
                local indent, bullet = l:match("^(%s*)([-*+])%s+%[[x ]%]")
                if indent then return indent .. bullet .. " [ ] " end

                -- Bullets
                indent, bullet = l:match("^(%s*)([-*+])%s+")
                if indent then return indent .. bullet .. " " end

                -- Numbers
                local num
                indent, num = l:match("^(%s*)(%d+)%.%s+")
                if indent then return indent .. (tonumber(num) + 1) .. ". " end

                return nil
            end

            local function is_continuation(l)
                return l:match("^%s+[^%-%*%+%d]")
            end

            -- LOGIC START
            local line = vim.api.nvim_get_current_line()

            -- Decide if we need to clear indentation on the new line (<C-u>).
            -- We only do this if the CURRENT line is indented.
            -- If it's not indented (root level), <C-u> might join lines in your config.
            local pad = ""
            if line:match("^%s") then
                pad = cu
            end

            -- A. Check current line for a list marker
            local prefix = prefix_from_line(line)
            if prefix then
                return cr .. pad .. prefix
            end

            -- B. Search upwards for context
            local row = vim.api.nvim_win_get_cursor(0)[1] - 1
            local lines = vim.api.nvim_buf_get_lines(0, 0, row, false)
            local empty = 0

            for i = #lines, 1, -1 do
                local l = lines[i]
                if l:match("^%s*$") then
                    empty = empty + 1
                    if empty >= 2 then break end
                elseif l:match("^#") then
                    break
                elseif is_continuation(l) then
                    -- skip continuation lines to find the parent
                else
                    empty = 0
                    prefix = prefix_from_line(l)
                    if prefix then
                        return cr .. pad .. prefix
                    end
                end
            end

            -- Fallback
            return cr
        end, { buffer = true, expr = true })
    end,
})

vim.keymap.set("n", "<Leader>ll", function()
    local filepath = vim.fn.expand("%")
    vim.cmd("silent !markdownlint --fix " .. filepath)
    vim.cmd("e!")
    print("Markdown list fixed.")
end)

vim.keymap.set("i", "<M-CR>", function()
    local cr = vim.api.nvim_replace_termcodes("<CR>", true, true, true)
    local cu = vim.api.nvim_replace_termcodes("<C-u>", true, true, true)

    local function prefix_from_line(line)
        local indent, bullet = line:match("^(%s*)([-*+])%s+%[[x ]%]")
        if indent then
            return indent .. bullet .. " [ ] "
        end

        indent, bullet = line:match("^(%s*)([-*+])%s+")
        if indent then
            return indent .. bullet .. " "
        end

        local num
        indent, num = line:match("^(%s*)(%d+)%.%s+")
        if indent then
            return indent .. (tonumber(num) + 1) .. ". "
        end

        return nil
    end

    local function is_continuation(line)
        return line:match("^%s+[^%-%*%+%d]")
    end

    -- CURRENT LINE
    local line = vim.api.nvim_get_current_line()

    -- Case 1: current line already has a list prefix
    local prefix = prefix_from_line(line)
    if prefix then
        return cr .. cu .. prefix
    end

    -- 🔴 IMPORTANT FIX:
    -- If current line is NOT indented, do NOT inherit a list
    if not line:match("^%s+") then
        return cr
    end

    -- Case 2: search upward for a list to continue
    local row = vim.api.nvim_win_get_cursor(0)[1] - 1
    local lines = vim.api.nvim_buf_get_lines(0, 0, row, false)
    local empty = 0

    for i = #lines, 1, -1 do
        local l = lines[i]

        if l:match("^%s*$") then
            empty = empty + 1
            if empty >= 2 then break end
        elseif l:match("^#") then
            break
        elseif is_continuation(l) then
            -- skip continuation lines
        else
            empty = 0
            prefix = prefix_from_line(l)
            if prefix then
                return cr .. cu .. prefix
            end
        end
    end

    -- Fallback: normal newline
    return cr
end, { buffer = true, expr = true })


