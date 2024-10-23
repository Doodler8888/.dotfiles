local leap = require("leap")

-- Then, define your keybindings
-- vim.keymap.set({"n", "x", "o"}, "//", function()
vim.keymap.set({"n", "x", "o"}, "s", function()
  leap.leap({direction = "forward"})
end, {desc = "Leap forward"})
