local cmp = require'cmp'
-- local luasnip = require'luasnip'

cmp.setup {
  -- snippet = {
  --   -- REQUIRED - you must specify a snippet engine
  --   expand = function(args)
  --     luasnip.lsp_expand(args.body) -- For `luasnip` users.
  --   end,
  -- },
  sources = {
    -- { name = 'luasnip' }, -- For luasnip users.
    { name = 'path', max_item_count = 4 },
    -- { name = 'cmdline', max_item_count = 4, keyword_pattern = [[^[^w]\w*$]] },
  },
  mapping = {
   ['<C-a>'] = cmp.mapping.confirm({ select = true }),
  },
}

vim.api.nvim_set_keymap("i", "<Tab>", "<cmd>lua require'luasnip'.jump(1)<Cr>", {silent = true})
vim.api.nvim_set_keymap("s", "<Tab>", "<cmd>lua require'luasnip'.jump(1)<Cr>", {silent = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "<cmd>lua require'luasnip'.jump(-1)<Cr>", {silent = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "<cmd>lua require'luasnip'.jump(-1)<Cr>", {silent = true})


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

-- -- ~/.config/nvim/snippets.lua
-- local ls = require 'luasnip'
--
-- -- Define your snippets here
-- ls.snippets = {
--     -- Snippets for yaml files
--     yaml = {
--         -- Triggered by 'ansible.builtn.'
--         ls.parser.parse_snippet("ansible.builtn.", "ansible.builtn.$1")
--         -- The $1 represents the cursor position after expansion
--     },
--     -- You can define snippets for other file types here
-- }
--
