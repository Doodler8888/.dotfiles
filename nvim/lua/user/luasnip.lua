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
s("args", {
  -- t({"import argparse", "", "parser = argparse.ArgumentParser("}),
  t({"parser = argparse.ArgumentParser("}),
  t({"", "                    prog='"}), i(1, "program_name"), t({"',"}),
  t({"", "                    description='"}), i(2, "description_here"), t({"',"}),
  t({"", "                    add_help="}), i(3, "True"), t({")"}),
  t({"", "parser.add_argument('"}), i(4, "name_of_the_main_argument_for_the_parser"), t({"', nargs='+', help='"}), i(5, "argument_help"), t({"')"}),
  t({"", "parser.add_argument('"}), i(6, "short_flag"), t({"', '"}), i(7, "long_flag"), t({"', action='store_true', help='"}), i(8, "flag_help"), t({"')"}),
  t({"", "", "args = parser.parse_args()"}
  )
})
})

ls.add_snippets("markdown", {
    s("code", {
        t({"```", ""}),
        i(1),  -- Default insert node content
        t({"", "```"}),
    }),
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
    s("yaml", {
        t({"``` yaml", ""}),
        i(1),  -- Default insert node content
        t({"", "```"}),
    }),
})

ls.add_snippets("yaml", {
  s("name", { t("app.kubernetes.io/name: ") }),
})
