local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node  -- add the insert node

vim.keymap.set({"i"}, "<C-H>", function() ls.expand() end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})

-- vim.keymap.set({"i", "s"}, "<C-E>", function()
-- 	if ls.choice_active() then
-- 		ls.change_choice(1)
-- 	end
-- end, {silent = true})

ls.add_snippets("python", {
  -- subprocess.run() with shell=True and check=True
  s("srsc", {
    t('subprocess.run("'),
    i(1, ""),  -- cursor will be here between the quotes
    t('", shell=True, check=True)'),
  }),
  -- subprocess.run() with shell=True
  s("srs", {
    t('subprocess.run("'),
    i(1, ""),  -- cursor will be here between the quotes
    t('", shell=True)'),
  }),
  -- Fixed: stdout=True replaced with stdout=subprocess.PIPE
  s("sr", {
    t('subprocess.run("'),
    i(1, ""),  -- cursor will be here between the quotes
    t('", shell=True, check=True, capture_output=True)'),
  }),
  s("sc", {
    t('subprocess.check_output("'),
    i(1, ""),  -- cursor will be here between the quotes
    t('", shell=True, text=True)'),
  }),
  s("p", {
      t('print("'),
      i(1),  -- Cursor inside the quotes
      t('")')
  }),
  s("pt", {
    t('print(f"This is the '),
    i(1, ""),  -- Cursor inside f-string expression
    t(' {'),
    i(2, ""),  -- Cursor inside curly braces
    t('}")'),
  }),
  s("li", {
    t('logging.info(f"'),
    i(1, ""),  -- Cursor inside f-string expression
    t(' {'),
    i(2, ""),  -- Cursor inside curly braces
    t('}")'),
  }),
  s("main", {
      t({'if __name__ == "__main__":', '    main('}),
      i(1),
      t({')'})
  }),
})

ls.add_snippets("markdown", {
    s("bash", {
        t({"``` bash", ""}),
        i(1),  -- Default insert node content
        t({"", "```"}),
    }),
    s("py", {
        t({"``` python", ""}),
        i(1),  -- Default insert node content
        t({"", "```"}),
    }),
    s("python", {
        t({"``` python", ""}),
        i(1),  -- Default insert node content
        t({"", "```"}),
    }),
    s("code", {
        t({"```", ""}),
        i(1),  -- Default insert node content
        t({"", "```"}),
    }),
})

