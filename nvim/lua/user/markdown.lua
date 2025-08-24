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


-- vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
--   pattern = {"*.md", "*.markdown"},
--   callback = function()
--     local lnum = vim.fn.line(".")
--     local col = vim.fn.col(".")
--     local concealed = vim.fn.synconcealed(lnum, col) ~= 0
--     if concealed and vim.wo.concealcursor ~= "" then
--       vim.wo.concealcursor = ""
--     elseif not concealed and vim.wo.concealcursor ~= "nc" then
--       vim.wo.concealcursor = "nc"
--     end
--   end,
-- })


-- This plugin takes over the secondary 's' binding, it makes it impossible to
-- use it with surrounding-plugings in markdown files. That's why i explicitely
-- disabled them.
require("markdown").setup({
  -- Disable all keymaps by setting mappings field to 'false'.
  -- Selectively disable keymaps by setting corresponding field to 'false'.
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

