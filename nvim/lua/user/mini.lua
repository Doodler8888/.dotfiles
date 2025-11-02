require("mini.pairs").setup({
})
require("mini.git").setup({
})
-- require("mini.diff").setup({
-- })
require('mini.statusline').setup({
  content = {
    active = function()
      local git = MiniStatusline.section_git({ trunc_width = 0 })
      local filename = MiniStatusline.section_filename({ trunc_width = 0 })

      return MiniStatusline.combine_groups({
        { hl = 'MiniStatuslineFilename', strings = { filename } },
        '%=', -- End left alignment (pushes git to the right)
        { hl = 'MiniStatuslineDevinfo', strings = { git } },
      })
    end,
    inactive = function()
      local git = MiniStatusline.section_git({ trunc_width = 0 })
      local filename = MiniStatusline.section_filename({ trunc_width = 0 })

      return MiniStatusline.combine_groups({
        { hl = 'MiniStatuslineInactive', strings = { filename } },
        '%=', -- End left alignment (pushes git to the right)
        { hl = 'MiniStatuslineInactive', strings = { git } },
      })
    end,
  },
})
-- require("mini.pick").setup({
-- })
-- require("mini.completion").setup({
-- })
require("mini.ai").setup({
})
-- require("mini.bracketed").setup({
-- })
