-- Define the snippet.add function
function vim.snippet.add(trigger, body, opts)
    vim.keymap.set("ia", trigger, function()
        local c = vim.fn.nr2char(vim.fn.getchar(0))
        if c == ']' then
            vim.snippet.expand(body)
        else
            vim.api.nvim_feedkeys(trigger .. c, "i", true)
        end
    end, opts)
end

-- Set up Lua snippets
vim.api.nvim_create_autocmd("FileType", {
    pattern = "lua",
    callback = function(ev)
        -- Normal function snippet
        vim.snippet.add("fn",
            "function ${1:name}($2)\n\t${3}\nend\n",
            { buffer = ev.buf }
        )

        -- Local function snippet
        vim.snippet.add("sfn",
            "local function ${1:name}($2)\n\t${3}\nend\n",
            { buffer = ev.buf }
        )
    end,
    pattern = "python",
    callback = function(ev)
        -- Normal function snippet
        vim.snippet.add("srsc",
            "subprocess.run(\"${1}\", shell=True, Check=True)",
            { buffer = ev.buf }
        )

        -- -- Local function snippet
        -- vim.snippet.add("sfn",
        --     "subprocess.run(\"${1}\", shell=True, Check=True)",
        --     { buffer = ev.buf }
        -- )
    end,
})

















-- -- require("luasnip.loaders.from_snipmate").lazy_load()
--
-- local ls = require "luasnip"
-- local s = ls.snippet
-- local t = ls.text_node
-- local i = ls.insert_node
-- -- local extras = require("luasnip.extras")
-- -- local rep = extras.rep
-- -- local fmt = require("luasnip.extras.fmt").fmt
-- -- local c = ls.choice_node
-- -- local f = ls.function_node
-- -- local d = ls.dynamic_node
-- -- local sn = ls.snippet_node
--
-- ls.add_snippets("", {
--     s("hello", {
--         t('print("hello world'),
--     }),
--     s("<l", {
--       t('SELECT * FROM '),
--       i(1, 'name'),
--       t(' LIMIT 100'),
--     }),
--     -- s("<l", {
--     --     t('SELECT * FROM name LIMIT 100'),
--     -- }),
-- })
--
-- --     s("if", {
-- --         t('if '),
-- --         i(1, "true"),
-- --         t(' then '),
-- --         i(2),
-- --         t(' end')
-- --     })
-- -- })
