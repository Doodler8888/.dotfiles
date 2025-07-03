vim.opt.sessionoptions = 'curdir,folds,globals,help,tabpages,terminal,winsize'

_G.current_session_name = nil

local sessions_dir = vim.fn.stdpath('cache') .. '/sessions'
local tab_rename = require('user.tab_rename_mksession')
local oil_session = require('user.oil_session')

if vim.fn.isdirectory(sessions_dir) == 0 then
    vim.fn.mkdir(sessions_dir, "p")
end

local function get_session_path(session_name)
    return sessions_dir .. '/' .. session_name
end

local function get_tab_names_path(session_name)
    return get_session_path(session_name) .. '.tabnames'
end

local function get_oil_session_path(session_name)
    return get_session_path(session_name) .. '.oil'
end

function _G.load_session(session_name)
    if not session_name or session_name == "" then
        print("Session name is required")
        return
    end
    local session_path = get_session_path(session_name)
    if vim.fn.filereadable(session_path) == 1 then
        _G.current_session_name = session_name
        _G.session_loaded = true
        vim.cmd('source ' .. vim.fn.fnameescape(session_path))
    else
        print("Session not found: " .. session_path)
    end
end

function _G.save_session(session_name)
    local name_to_use = session_name or _G.current_session_name
    if not name_to_use or name_to_use == "" then
        name_to_use = vim.fn.input('Session Name: ')
        if name_to_use == "" then
            print("Session name is required")
            return
        end
    end

    local session_path = get_session_path(name_to_use)
    tab_rename.save_tab_names(session_path)
    oil_session.save_oil_buffers(session_path)
    vim.cmd('mksession! ' .. vim.fn.fnameescape(session_path))
    print("Session saved: " .. session_path)
    _G.current_session_name = name_to_use
    _G.session_loaded = true
end

function _G.rename_session(old_name, new_name)
    local old_session_path = get_session_path(old_name)
    local new_session_path = get_session_path(new_name)
    local old_tab_names_path = get_tab_names_path(old_name)
    local new_tab_names_path = get_tab_names_path(new_name)
    local old_oil_session_path = get_oil_session_path(old_name)
    local new_oil_session_path = get_oil_session_path(new_name)

    if vim.fn.filereadable(old_session_path) ~= 1 then
        print("Session not found: " .. old_session_path)
        return
    end

    if vim.fn.rename(old_session_path, new_session_path) == 0 then
        if vim.fn.filereadable(old_tab_names_path) == 1 then
            vim.fn.rename(old_tab_names_path, new_tab_names_path)
        end
        if vim.fn.filereadable(old_oil_session_path) == 1 then
            vim.fn.rename(old_oil_session_path, new_oil_session_path)
        end
        print("Session renamed from " .. old_name .. " to " .. new_name)
        if _G.current_session_name == old_name then
            _G.current_session_name = new_name
        end
    else
        print("Failed to rename session")
    end
end

function _G.delete_session(session_name)
    local session_path = get_session_path(session_name)
    local tab_names_path = get_tab_names_path(session_name)
    local oil_session_path = get_oil_session_path(session_name)

    if vim.fn.filereadable(session_path) ~= 1 then
        print("Session not found: " .. session_path)
        return
    end

    if vim.fn.delete(session_path) == 0 then
        if vim.fn.filereadable(tab_names_path) == 1 then
            vim.fn.delete(tab_names_path)
        end
        if vim.fn.filereadable(oil_session_path) == 1 then
            vim.fn.delete(oil_session_path)
        end
        print("\nSession deleted: " .. session_name)
        if _G.current_session_name == session_name then
            _G.current_session_name = nil
            _G.session_loaded = false
        end
    else
        print("Failed to delete session")
    end
end

local function list_sessions()
    local session_files = vim.fn.split(vim.fn.globpath(sessions_dir, '*'), "\n")
    local sessions = {}
    for _, file in ipairs(session_files) do
        if file and file ~= "" and not file:match('.tabnames$') and not file:match('.oil$') then
            table.insert(sessions, vim.fn.fnamemodify(file, ':t'))
        end
    end
    return sessions
end

function _G.rename_session_interactive()
    if not _G.current_session_name or _G.current_session_name == "" then
        print("No current session to rename.")
        return
    end
    local new_name = vim.fn.input('New session name: ')
    if new_name and new_name ~= "" then
        _G.rename_session(_G.current_session_name, new_name)
    else
        print("New session name is required.")
    end
end

function _G.choose_and_delete_session()
    local sessions = list_sessions()
    if #sessions == 0 then
        print("No sessions found.")
        return
    end
    local choice = vim.fn.inputlist(sessions)
    if choice > 0 and choice <= #sessions then
        _G.delete_session(sessions[choice])
    else
        print("Invalid session choice.")
    end
end

-- User Commands
vim.api.nvim_create_user_command('SaveSession', function(opts) _G.save_session(opts.args) end, { nargs = '?' })
vim.api.nvim_create_user_command('LoadSession', function(opts) _G.load_session(opts.args) end, { nargs = 1 })
vim.api.nvim_create_user_command('RenameSession', function(opts)
    local args = vim.split(opts.args, " ")
    if #args ~= 2 then
        print("Usage: RenameSession <old_name> <new_name>")
        return
    end
    _G.rename_session(args[1], args[2])
end, { nargs = '*' })
vim.api.nvim_create_user_command('RenameSessionInteractive', _G.rename_session_interactive, {})
vim.api.nvim_create_user_command('DeleteSession', _G.choose_and_delete_session, {})

-- Keymaps
vim.keymap.set('n', '<leader>ss', function() _G.save_session() end, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>sr', _G.rename_session_interactive, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>sd', _G.choose_and_delete_session, { noremap = true, silent = true })

-- Autocmds
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    if _G.session_loaded and _G.current_session_name then
      _G.save_session(_G.current_session_name)
    end
  end,
})

vim.api.nvim_create_autocmd("SessionLoadPost", {
    callback = function()
        local session_path = vim.v.this_session
        if session_path and session_path ~= "" then
            tab_rename.load_tab_names(session_path)
            oil_session.load_oil_buffers(session_path)
            vim.cmd('redrawtabline')
        end
    end,
})

-- Telescope Integration
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values

_G.session_picker = function(opts)
    opts = opts or {}
    local sessions = list_sessions()
    if #sessions == 0 then
        print("No sessions found.")
        return
    end

    local layout_config = {
        width = 0.5,
        height = 0.5,
        mirror = false,
        prompt_position = "bottom",
    }

    pickers.new(opts, {
        prompt_title = 'Load Session',
        finder = finders.new_table { results = sessions },
        sorter = conf.generic_sorter(opts),
        layout_strategy = "center",
        layout_config = layout_config,
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                _G.load_session(selection.value)
            end)
            return true
        end,
    }):find()
end

vim.api.nvim_create_user_command('LoadSessionPicker', function() _G.session_picker() end, {})
vim.keymap.set('n', '<leader>sl', function() _G.session_picker() end, { noremap = true, silent = true })

-- Require the module
local tabs1 = require('user.tab_rename_mksession')
vim.keymap.set('n', '<leader>tr', tabs1.set_tabname, { desc = "Rename tab" })