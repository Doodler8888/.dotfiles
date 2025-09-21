-- Define your pairs in a table.
local autopairs = {
  ["("] = ")",
  ["["] = "]",
  ["{"] = "}",
  ["'"] = "'",
  ['"'] = '"'
}

-- Set up autopair insertion in insert mode.
for open, close in pairs(autopairs) do
  vim.api.nvim_set_keymap('i', open, open .. close .. '<Left>', { noremap = true, silent = true })
end

-- Define a function for smart backspace.
function _G.smart_backspace()
  local col = vim.fn.col('.') - 1  -- Convert to 0-indexed
  local line = vim.fn.getline('.')
  if col < 1 then
    return vim.api.nvim_replace_termcodes("<BS>", true, true, true)
  end
  local char_before = line:sub(col, col)
  local char_after  = line:sub(col + 1, col + 1)
  if autopairs[char_before] and char_after == autopairs[char_before] then
    return vim.api.nvim_replace_termcodes("<BS><Del>", true, true, true)
  else
    return vim.api.nvim_replace_termcodes("<BS>", true, true, true)
  end
end

-- Remap backspace in insert mode to use the smart backspace function.
vim.api.nvim_set_keymap('i', '<BS>', 'v:lua.smart_backspace()', { expr = true, noremap = true })
