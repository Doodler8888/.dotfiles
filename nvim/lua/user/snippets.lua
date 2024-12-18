-- require("luasnip.loaders.from_snipmate").lazy_load()

local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
-- local extras = require("luasnip.extras")
-- local rep = extras.rep
-- local fmt = require("luasnip.extras.fmt").fmt
-- local c = ls.choice_node
-- local f = ls.function_node
-- local d = ls.dynamic_node
-- local sn = ls.snippet_node

ls.add_snippets("", {
    s("hello", {
        t('print("hello world'),
    }),
    s("<l", {
      t('SELECT * FROM '),
      i(1, 'name'),
      t(' LIMIT 100'),
    }),
    -- s("<l", {
    --     t('SELECT * FROM name LIMIT 100'),
    -- }),
})

--     s("if", {
--         t('if '),
--         i(1, "true"),
--         t(' then '),
--         i(2),
--         t(' end')
--     })
-- })
