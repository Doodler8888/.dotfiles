local cmp = require'cmp'
local luasnip = require'luasnip'

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  sources = {
    { name = 'path', max_item_count = 4 },
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'vim-dadbod-completion' },
    { name = 'luasnip' },
  },
  mapping = {
    ['<C-a>'] = cmp.mapping.confirm({ select = true }),
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
}

-- function _G.toggle_cmp()
--  if cmp.visible() then
--     cmp.close()
--  else
--     cmp.complete()
--  end
-- end
--
-- vim.api.nvim_set_keymap('i', '<C-x><C-c>', '<cmd>lua toggle_cmp()<CR>', {expr = true, noremap = true})


-- -- cmdline setup
-- cmp.setup.cmdline(':', {
--   sources = {
--     { name = 'cmdline', max_item_count = 4, keyword_pattern = [[^[^sw]\s*\w*$]] },
--   },
--   mappings = cmp.mapping.preset.cmdline(),
--   options = {
--     ignore_cmds = { 'Man', '!' },
--   }
-- })

