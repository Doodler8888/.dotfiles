vim.keymap.set(
  "n",
  "gwe", -- see :h gw to figure out why this makes sense.
  require("wrapping-paper").wrap_line,
  { desc = "fake wrap current line" }
)
