-- This plugin takes over the secondary 's' binding, it makes it impossible to
-- use it with surrounding-plugings in markdown files. That's why i explicitely
-- disabled them.
require("markdown").setup({
  -- Disable all keymaps by setting mappings field to 'false'.
  -- Selectively disable keymaps by setting corresponding field to 'false'.
    on_attach = function(bufnr)
        local map = vim.keymap.set
        -- The { buffer = bufnr } part is important. It makes the keymap
        -- only apply to markdown files that this plugin is attached to.
        local opts = { buffer = bufnr, silent = true }

        -- 1. In NORMAL mode, press C-c C-c to toggle the task on the current line
        map('n', '<C-c><C-c>', '<Cmd>MDTaskToggle<CR>', opts)

        -- 2. In VISUAL mode, select lines and press C-c C-c to toggle all their tasks
        map('x', '<C-c><C-c>', ':MDTaskToggle<CR>', opts)
    end,
  mappings = {
    -- inline_surround_toggle = "gs", -- (string|boolean) toggle inline style
    inline_surround_toggle = false, -- (string|boolean) toggle inline style
    -- inline_surround_toggle_line = "gss", -- (string|boolean) line-wise toggle inline style
    inline_surround_toggle_line = false, -- (string|boolean) line-wise toggle inline style
    -- inline_surround_delete = "ds", -- (string|boolean) delete emphasis surrounding cursor
    inline_surround_delete = false, -- (string|boolean) delete emphasis surrounding cursor
    -- inline_surround_change = "cs", -- (string|boolean) change emphasis surrounding cursor
    inline_surround_change = false, -- (string|boolean) change emphasis surrounding cursor
    go_curr_heading = "]c", -- (string|boolean) set cursor to current section heading
    go_parent_heading = "]p", -- (string|boolean) set cursor to parent section heading
    go_next_heading = "]]", -- (string|boolean) set cursor to next section heading
    go_prev_heading = "[[", -- (string|boolean) set cursor to previous section heading
  },
})

local modifier = vim.fn.has('mac') == 1 and '<D-' or '<A-'

-- -- For some reason, it just doesn't work
-- vim.keymap.set('i', '<M-CR>', '<cmd>MDListItemBelow<CR>')
vim.keymap.set('i', modifier .. 'CR>', '<cmd>MDListItemBelow<CR>')

