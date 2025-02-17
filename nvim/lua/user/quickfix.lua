vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.opt_local.wrap = true       -- Enable line wrapping
    vim.opt_local.linebreak = true  -- Wrap at word boundaries
    -- -- Optional: Disable line numbers
    -- vim.opt_local.number = false
    -- vim.opt_local.relativenumber = false
  end
})

vim.keymap.set('n', '<CR>', ':cc<CR>', { noremap = true, silent = true, desc = "Go to current quickfix item" })
vim.keymap.set('n', '<C-M-n>', ':cnext<CR>', { noremap = true, silent = true, desc = "Next quickfix item" })
vim.keymap.set('n', '<C-M-p>', ':cprev<CR>', { noremap = true, silent = true, desc = "Previous quickfix item" })

local M = {}

-- Keep separate quickfix lists using context markers
local qf_context = {
    compile = 'COMPILATION',
    lsp = 'LSP_DIAGNOSTICS'
}

-- Modified toggle function with context awareness
local function toggle_quickfix_diagnostics()
    -- Check if current window is quickfix
    local current_win = vim.api.nvim_get_current_win()
    local is_quickfix = vim.bo[vim.api.nvim_win_get_buf(current_win)].ft == 'qf'

    -- Find a valid original window
    local original_win
    if is_quickfix then
        -- Use previous window if available
        original_win = vim.fn.win_getid(vim.fn.winnr('#'))
    else
        original_win = current_win
    end

    -- Get quickfix info
    local qf_info = vim.fn.getqflist({ winid = 1, context = 1 })

    -- Check if we should close
    if qf_info.winid ~= 0 then
        if qf_info.context and qf_info.context.diagnostics then
            vim.cmd.cclose()
            -- Ensure window still exists before switching
            if vim.api.nvim_win_is_valid(original_win) then
                vim.api.nvim_set_current_win(original_win)
            end
            return
        end
        vim.cmd.cclose()
    end

    -- Only proceed if not in quickfix window
    if not is_quickfix then
        local diagnostics = vim.diagnostic.get(0)
        if #diagnostics == 0 then
            print("No LSP diagnostics found")
            return
        end

        vim.fn.setqflist({}, ' ', {
            title = 'LSP Diagnostics',
            context = { diagnostics = true },
            items = vim.diagnostic.toqflist(diagnostics)
        })

        vim.cmd('botright copen')

        -- Return focus only if original window is valid
        if vim.api.nvim_win_is_valid(original_win) then
            vim.api.nvim_set_current_win(original_win)
        end
    end
end

-- Enhanced compilation system
M.compile_commands = {
    c = "gcc -Wall -Wextra -o %< %",
    sh = "shellcheck -f gcc %",
    go = "go vet % && go build %",
}

function M.setup_compile()
    local ft = vim.bo.filetype
    if M.compile_commands[ft] then
        vim.o.makeprg = M.compile_commands[ft]
    end
end

-- Modified compile function with window preservation
function M.compile(original_win)
    -- Store current window if not provided
    original_win = original_win or vim.api.nvim_get_current_win()

    vim.cmd('write')
    vim.cmd('silent! make!')

    local qf_list = vim.fn.getqflist()
    if #qf_list > 0 then
        -- Open quickfix without changing focus
        vim.cmd('botright copen')
        -- Immediately return focus to original window
        vim.api.nvim_set_current_win(original_win)
    else
        print("Compilation successful")
    end
end

-- Universal toggle function that preserves context
function M.toggle_compile_qf()
    -- Get current window and check if it's quickfix
    local current_win = vim.api.nvim_get_current_win()
    local is_quickfix = vim.bo[vim.api.nvim_win_get_buf(current_win)].ft == 'qf'

    -- Find valid original window
    local original_win
    if is_quickfix then
        -- Use previous window if available
        original_win = vim.fn.win_getid(vim.fn.winnr('#'))
    else
        original_win = current_win
    end

    -- Check if quickfix is open
    local qf_info = vim.fn.getqflist({ winid = 1 })
    if qf_info.winid ~= 0 then
        vim.cmd.cclose()
        -- Only switch back if window is valid
        if original_win and vim.api.nvim_win_is_valid(original_win) then
            vim.api.nvim_set_current_win(original_win)
        end
        return
    end

    -- Run compilation if quickfix wasn't open
    if not is_quickfix then
        M.compile(original_win)
    end
end

-- Key mappings
vim.keymap.set('n', '<M-l>', toggle_quickfix_diagnostics,
    {noremap = true, silent = true, desc = "LSP Diagnostics"})
vim.keymap.set('n', '<M-y>', M.toggle_compile_qf, {
    silent = true,
    desc = "Toggle compilation quickfix"
})
-- vim.keymap.set('n', '<M-y>', M.toggle_qf,
--     {silent = true, desc = "Toggle quickfix context"})

-- Autocommands
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"c", "cpp", "rust", "go", "sh"},
    callback = M.setup_compile
})

return M
