require('nvim-surround').setup({
  keymaps = {
    insert = "<C-s>",
    insert_line = "<C-s>s",
    normal = "ys",
    normal_cur = "yss",
    normal_line = "yS",
    normal_cur_line = "ySS",
    visual = "S",
    visual_line = "gS",
    delete = "ds",
    change = "cs",
  }
})

-- Unmap the old bindings manually
-- vim.api.nvim_del_keymap('i', '<C-g>')
-- vim.api.nvim_del_keymap('i', '<C-g>s')
-- vim.api.nvim_del_keymap('i', '<C-g>S')
