-- Initialize a table to hold the "numbered" marks
Num_marks = {}

-- Function to set a "numbered" mark
function Set_num_mark(num)
    local file = vim.fn.expand("%:p")
    local line = vim.fn.line(".")
    local col = vim.fn.col(".")
    Num_marks[num] = { file = file, line = line, col = col }
end

-- Function to go to a "numbered" mark
function Goto_num_mark(num)
    if Num_marks[num] then
        local mark = Num_marks[num]
        vim.api.nvim_command("e " .. mark.file)
        vim.api.nvim_command("normal! " .. mark.line .. "G" .. mark.col .. "|")
    else
        print("No mark set for number " .. num)
    end
end

-- Create Neovim commands to use these functions
vim.api.nvim_command("command! -nargs=1 SetNumMark lua Set_num_mark(<args>)")
vim.api.nvim_command("command! -nargs=1 GotoNumMark lua Goto_num_mark(<args>)")


function Save_num_marks()
    local file = io.open(vim.fn.stdpath("config") .. "/.num_marks.txt", "w")
    if file then
        file:write(vim.fn.json_encode(Num_marks))
        file:close()
    end
end

function Load_num_marks()
    local file = io.open(vim.fn.stdpath("config") .. "/.num_marks.txt", "r")
    if file then
        local content = file:read("*all")
        file:close()
        Num_marks = vim.fn.json_decode(content)
    end
end

vim.api.nvim_command("autocmd VimEnter * lua Load_num_marks()")
vim.api.nvim_command("autocmd VimLeave * lua Save_num_marks()")

