-- Ensure ripgrep is executable
if vim.fn.executable "rg" == 1 then
    -- Function to fuzzy find FILES using ripgrep for the :find command
    function _G.RgFindFiles(cmdarg, _)
        local fnames = vim.fn.systemlist('rg --files --hidden --color=never --glob="!.git"')
        if #cmdarg == 0 then
            return fnames
        else
            return vim.fn.matchfuzzy(fnames, cmdarg)
        end
    end

    -- Function to fuzzy find DIRECTORIES for our custom command
    function _G.RgFindDirs(cmdarg, _)
        -- THE FIX: Use `sort -u` to get a properly sorted and unique list of directories.
        local dirs = vim.fn.systemlist('rg --files --hidden --color=never --glob="!.git" | xargs -n 1 dirname | sort -u')
        if #cmdarg == 0 then
            return dirs
        else
            -- Return a fuzzy-matched list
            return vim.fn.matchfuzzy(dirs, cmdarg)
        end
    end
end

-- Set the findfunc for the built-in :find command to use our file finder
vim.o.findfunc = 'v:lua.RgFindFiles'

-- Create a new custom command `:FindDir` that will open a directory with oil.nvim
vim.api.nvim_create_user_command('FindDir', function(opts)
    if opts.args and #opts.args > 0 then
        vim.cmd('Oil ' .. vim.fn.fnameescape(opts.args))
    end
end, {
    nargs = 1,
    -- Tell our new command to use our RgFindDirs function for completion
    complete = function(arglead, cmdline, cursorpos)
        return _G.RgFindDirs(arglead, cmdline)
    end,
})

-- Autocommand to trigger completion automatically as you type
vim.api.nvim_create_autocmd({ 'CmdlineChanged', 'CmdlineLeave' }, {
    pattern = { '*' },
    group = vim.api.nvim_create_augroup('CmdlineFuzzyFind', { clear = true }),
    callback = function(ev)
        local cmdline_cmd = vim.fn.split(vim.fn.getcmdline(), ' ')[1]

        -- Enable autocompletion for :find and for our new :FindDir command
        local function should_enable_autocomplete()
            return cmdline_cmd == 'find' or cmdline_cmd == 'fin' or cmdline_cmd == 'FindDir'
        end

        if ev.event == 'CmdlineChanged' and should_enable_autocomplete() then
            vim.opt.wildmode = 'noselect:lastused,full'
            vim.fn.wildtrigger()
        end

        if ev.event == 'CmdlineLeave' then
            vim.opt.wildmode = 'full'
        end
    end
})


-- KEYBINDINGS --

-- Keymap for finding files (uses the built-in :find command)
vim.keymap.set('n', '<leader>ff', ':find<space>', { desc = 'Fuzzy find files' })

-- Keymap for finding directories (uses our new :FindDir command)
vim.keymap.set('n', '<leader>fd', ':FindDir<space>', { desc = 'Fuzzy find directories (Oil)' })


-- vim.keymap.set('c', '<C-f>', function()
--     if vim.fn.wildmenumode() then
--         return vim.api.nvim_replace_termcodes('<C-e><Right>', true, false, true)
--     else
--         return '<Right>'
--     end
-- end, { expr = true })
--
-- vim.keymap.set('c', '<C-b>', function()
--     if vim.fn.wildmenumode() then
--         return vim.api.nvim_replace_termcodes('<C-e><Left>', true, false, true)
--     else
--         return '<Left>'
--     end
-- end, { expr = true })
