require("mini.pairs").setup({
})
require("mini.git").setup({
})
require('mini.statusline').setup({
  content = {
    active = function()
      local git = MiniStatusline.section_git({ trunc_width = 0 })

      return MiniStatusline.combine_groups({
        { hl = 'MiniStatuslineFilename', strings = { '%f', '%m' } },
        '%=',
        { hl = 'MiniStatuslineDevinfo', strings = { git } },
      })
    end,
    inactive = function()
      local git = MiniStatusline.section_git({ trunc_width = 0 })

      return MiniStatusline.combine_groups({
        { hl = 'MiniStatuslineInactive', strings = { '%f', '%m' } },
        '%=',
        { hl = 'MiniStatuslineInactive', strings = { git } },
      })
    end,
  },
})

vim.api.nvim_set_hl(0, 'MiniStatuslineFilename', { link = 'StatusLine' })
vim.api.nvim_set_hl(0, 'MiniStatuslineDevinfo', { link = 'StatusLine' })
vim.api.nvim_set_hl(0, 'MiniStatuslineInactive', { link = 'StatusLine' })
-- require("mini.pick").setup({
-- })
-- require("mini.completion").setup({
-- })
require("mini.ai").setup({
})
-- require("mini.bracketed").setup({
-- })
