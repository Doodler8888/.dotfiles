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
    ['<C-n>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
      else
        cmp.complete()
      end
    end, { 'i', 's', 'c' }),
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  completion = {
    autocomplete = false, -- Disable the default autocomplete behavior
  },
}

cmp.setup.cmdline(':', {
  mapping = {
    ['<C-n>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
      else
        cmp.complete()
      end
    end, { 'c' }),
    ['<C-p>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
	cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
      else
	fallback() -- Allow default behavior if cmp isn't active
      end
    end, { 'c' }),
  },
  sources = cmp.config.sources({
    { name = 'path' },
    { name = 'cmdline' },
  }),
  matching = { disallow_symbol_nonprefix_matching = false },
})

-- Set up manual trigger keybinding
-- vim.api.nvim_set_keymap('i', '<C-n>', '<Plug>luasnip-expand-or-jump', { silent = true })
vim.api.nvim_set_keymap('i', '<TAB>', '<Plug>luasnip-expand-or-jump', { silent = true })

-- local cmp = require'cmp'
--
-- local luasnip = require'luasnip'
--
-- cmp.setup {
--
-- snippet = {
--
-- expand = function(args)
--
-- luasnip.lsp_expand(args.body)
--
-- end,
--
-- },
--
-- sources = {
--
-- { name = 'path', max_item_count = 4 },
--
-- { name = 'nvim_lsp' },
--
-- -- { name = 'cmdline' },
-- { name = 'cmdline' },
-- -- { name = 'buffer' },
--
-- { name = 'vim-dadbod-completion' },
--
-- { name = 'luasnip' },
--
-- },
--
--
-- mapping = {
--
-- ['<C-a>'] = cmp.mapping.confirm({ select = true }),
--
-- ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
--
-- ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
--
-- },
--
-- window = {
--
-- completion = cmp.config.window.bordered(),
--
-- documentation = cmp.config.window.bordered(),
--
-- },
--
-- cmp.setup.cmdline(':', {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = cmp.config.sources({
--     { name = 'path' }
--   }, {
--     { name = 'cmdline' }
--   }),
--   matching = { disallow_symbol_nonprefix_matching = false }
-- })
--
-- }













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

