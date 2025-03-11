local cmp = require'cmp'
local luasnip = require'luasnip'
-- local cmp_autopairs = require('nvim-autopairs.completion.cmp')

-- cmp.event:on(
--   'confirm_done',
--   cmp_autopairs.on_confirm_done()
-- )

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  sources = {
    { name = 'path',
	  max_item_count = 10;
	  options = {
        -- get_cwd = function() return vim.fn.getcwd() end,
        -- trailing_slash = true
	  }
    },
    { name = 'nvim_lsp' },
    -- { name = 'conjure' },
    { name = 'buffer' },
    -- { name = 'vim-dadbod-completion' },
    { name = 'luasnip' },
  },
  mapping = {
    -- ['<Tab>'] = cmp.mapping(function(fallback)
    --   if cmp.visible() then
    --     cmp.confirm({ select = true })
    --   else
    --     cmp.complete()
    --   end
    -- end, { 'i', 's', 'c' }),

['<Tab>'] = cmp.mapping(function(fallback)
  if cmp.visible() then
    local entries = cmp.get_entries()
    if entries and #entries == 1 then
      cmp.confirm({ select = true })
    else
      -- If an item is selected, confirm it. Otherwise, move to next item
      local entry = cmp.get_active_entry()
      if entry then
        cmp.confirm({ select = true })
      else
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
      end
    end
  else
    cmp.complete()
    -- Defer the check to allow entries to populate
    vim.defer_fn(function()
      local entries = cmp.get_entries()
      if entries and #entries == 1 then
        cmp.confirm({ select = true })
      end
    end, 0)
  end
end, { 'i', 's', 'c' }),
    ['<C-n>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
      else
        fallback()
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
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        local entries = cmp.get_entries()
        if entries and #entries == 1 then
          cmp.confirm({ select = true })
        else
          -- If an item is selected, confirm it. Otherwise, move to next item
          local entry = cmp.get_active_entry()
          if entry then
            cmp.confirm({ select = true })
          else
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
          end
        end
      else
        cmp.complete()
        -- Defer the check to allow entries to populate
        vim.defer_fn(function()
          local entries = cmp.get_entries()
          if entries and #entries == 1 then
            cmp.confirm({ select = true })
          end
        end, 0)
      end
    end),
    -- ['<Tab>'] = cmp.mapping(function(fallback)
    --   if cmp.visible() then
    --     cmp.confirm({ select = true })
    --   else
    --     cmp.complete()
    --   end
    -- end, { 'c' }),
    ['<C-n>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
      else
        fallback()
      end
    end, { 'c' }),
    ['<C-p>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
      else
        fallback()
      end
    end, { 'c' }),
  },
  sources = cmp.config.sources({
    { name = 'path' },
    { name = 'cmdline' },
  }),
  matching = { disallow_symbol_nonprefix_matching = false },
})

cmp.setup.filetype({ "sql" }, {
  sources = {
    { name = "vim-dadbod-completion"},
    { name = "buffer" },
  },
})

-- vim.api.nvim_create_autocmd("TextChangedI", {
--   callback = function()
--     local col = vim.fn.col('.') - 1
--     if col <= 0 then
--       return
--     end
--     local line = vim.fn.getline('.')
--     local char = line:sub(col, col)
--     local prev_char = line:sub(col - 1, col - 1)
--
--     -- Trigger completion only if:
--     -- 1. The char is '/' not preceded by 's' or '/'
--     -- 2. The char is '~'
--     -- 3. The char is '.' preceded by '/'
--     if (char == '/' and prev_char ~= 's' and prev_char ~= '/' and prev_char ~= '\\' ) or
--        char == '~' or
--        (char == '.' and prev_char == '/') then
--       require("cmp").complete()
--     end
--   end,
-- })
