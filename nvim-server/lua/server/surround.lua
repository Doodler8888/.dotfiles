vim.api.nvim_set_keymap('v', '<Leader>"', [[<Esc>`>a"<Esc>`<i"<Esc>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', "<Leader>'", [[<Esc>`>a'<Esc>`<i'<Esc>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<Leader>(', "<Esc>`>a)<Esc>`<i(<Esc>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<Leader>)', "<Esc>`>a )<Esc>`<i( <Esc>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<Leader>[', "<Esc>`>a]<Esc>`<i[<Esc>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<Leader>]', "<Esc>`>a ]<Esc>`<i[ <Esc>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<Leader>{', "<Esc>`>a}<Esc>`<i{<Esc>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<Leader>}', "<Esc>`>a }<Esc>`<i{ <Esc>", { noremap = true, silent = true })

function SurroundWithCharWord()
  -- Get a character from the user
  local oldChar = vim.fn.nr2char(vim.fn.getchar())

  -- Define the pairs
  local pairs = { ['('] = ')', ['['] = ']', ['{'] = '}' }
  local rev_pairs = { [')'] = '(', [']'] = '[', ['}'] = '{' }

  -- Determine the opening and closing characters and spacing
  local openingChar, closingChar, spacing
  if pairs[oldChar] then
    openingChar = oldChar
    closingChar = pairs[oldChar]
    spacing = ''
  elseif rev_pairs[oldChar] then
    openingChar = rev_pairs[oldChar]
    closingChar = oldChar
    spacing = ' '
  else
    openingChar = oldChar
    closingChar = oldChar
    spacing = ''
  end

  -- Define the mapping
  local mapping = 'viw<Esc>`>a' .. spacing .. closingChar .. '<Esc>`<i' .. openingChar .. spacing .. '<Esc>'

  -- Execute the mapping
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(mapping, true, true, true), 'n', true)
end

function SurroundWithCharWORD()
  -- Get a character from the user
  local oldChar = vim.fn.nr2char(vim.fn.getchar())

  -- Define the pairs
  local pairs = { ['('] = ')', ['['] = ']', ['{'] = '}' }
  local rev_pairs = { [')'] = '(', [']'] = '[', ['}'] = '{' }

  -- Determine the opening and closing characters and spacing
  local openingChar, closingChar, spacing
  if pairs[oldChar] then
    openingChar = oldChar
    closingChar = pairs[oldChar]
    spacing = ''
  elseif rev_pairs[oldChar] then
    openingChar = rev_pairs[oldChar]
    closingChar = oldChar
    spacing = ' '
  else
    openingChar = oldChar
    closingChar = oldChar
    spacing = ''
  end

  -- Define the mapping
  local mapping = 'viW<Esc>`>a' .. spacing .. closingChar .. '<Esc>`<i' .. openingChar .. spacing .. '<Esc>'

  -- Execute the mapping
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(mapping, true, true, true), 'n', true)
end


function DeleteLastCharOfSelection()
  local cur_col = vim.fn.col('.')
  local cur_line = vim.fn.line('.')
  local oldChar = vim.fn.matchstr(vim.fn.getline(cur_line), ".", cur_col - 1)

  if oldChar == "'" or oldChar == '"' then
    vim.api.nvim_feedkeys('vi' .. oldChar .. 'l', 'n', false)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, true, true), 'n', false)
    vim.api.nvim_feedkeys('x', 'n', false)
    vim.api.nvim_feedkeys('F' .. oldChar, 'n', false)
    vim.api.nvim_feedkeys('x', 'n', false)

  elseif oldChar == '}' or oldChar == ']' or oldChar == ')' then
    local rev_pairs = { [')'] = '(', [']'] = '[', ['}'] = '{' }
    vim.api.nvim_feedkeys('vi' .. oldChar .. 'l', 'n', false)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, true, true), 'n', false)
    vim.api.nvim_feedkeys('x', 'n', false)
    oldChar = rev_pairs[oldChar]
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('F' .. oldChar, true, true, true), 'n', false)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('x', true, true, true), 'n', false)

  elseif oldChar == '{' or oldChar == '[' or oldChar == '(' then
    vim.api.nvim_feedkeys('vi' .. oldChar .. 'l', 'n', false)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, true, true), 'n', false)
    vim.api.nvim_feedkeys('x', 'n', false)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('F' .. oldChar, true, true, true), 'n', false)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('x', true, true, true), 'n', false)
  end
end

function SubstitutePairChars()
  -- Get the character under the cursor
  local col = vim.fn.col('.')
  local line = vim.fn.line('.')
  local oldChar = vim.fn.matchstr(vim.fn.getline(line), '.', col - 1)
  local right_rev_pairs = { [')'] = '(', [']'] = '[', ['}'] = '{' }
  local left_rev_pairs = { ['('] = ')', ['['] = ']', ['{'] = '}' }

  -- Get a character from the user for substitution
  local newChar = vim.fn.nr2char(vim.fn.getchar())

  -- Perform visual selection around the pair
  vim.api.nvim_feedkeys('vi' .. oldChar .. 'l', 'n', false)

  -- Cancel the selection and enter normal mode
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, true, true), 'n', false)

  -- Substitute the last character
  if newChar == '(' or newChar == '[' or newChar == '{' then
   if oldChar == '}' or oldChar == ']' or oldChar == ')' then
    newChar = left_rev_pairs[newChar]
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('r' .. newChar, true, true, true), 'n', false)
    newChar = right_rev_pairs[newChar]
    oldChar = right_rev_pairs[oldChar]
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('F' .. oldChar, true, true, true), 'n', false)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('r' .. newChar, true, true, true), 'n', false)
   elseif oldChar == '(' or oldChar == '[' or oldChar == '{' then
    newChar = left_rev_pairs[newChar]
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('r' .. newChar, true, true, true), 'n', false)
    newChar = right_rev_pairs[newChar]
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('F' .. oldChar, true, true, true), 'n', false)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('r' .. newChar, true, true, true), 'n', false)
   end
  elseif newChar == ')' or newChar == ']' or newChar == '}' then
   if oldChar == '(' or oldChar == '[' or oldChar == '{' then
    print("oldChar: " .. tostring(oldChar))
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('r' .. newChar, true, true, true), 'n', false)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('F' .. oldChar, true, true, true), 'n', false)
    newChar = right_rev_pairs[newChar]
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('r' .. newChar, true, true, true), 'n', false)
   elseif oldChar == ')' or oldChar == ']' or oldChar == '}' then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('r' .. newChar, true, true, true), 'n', false)
    newChar = right_rev_pairs[newChar]
    oldChar = right_rev_pairs[oldChar]
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('F' .. oldChar, true, true, true), 'n', false)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('r' .. newChar, true, true, true), 'n', false)
   end
  else
   if oldChar == '(' or oldChar == '[' or oldChar == '{' then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('r' .. newChar, true, true, true), 'n', false)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('F' .. oldChar, true, true, true), 'n', false)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('r' .. newChar, true, true, true), 'n', false)
   elseif oldChar == ')' or oldChar == ']' or oldChar == '}' then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('r' .. newChar, true, true, true), 'n', false)
    oldChar = right_rev_pairs[oldChar]
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('F' .. oldChar, true, true, true), 'n', false)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('r' .. newChar, true, true, true), 'n', false)
 else
     vim.api.nvim_feedkeys('r' .. newChar, 'n', false)
     vim.api.nvim_feedkeys('F' .. oldChar, 'n', false)
     vim.api.nvim_feedkeys('r' .. newChar, 'n', false)
   end
  end
end


vim.api.nvim_set_keymap('n', '<Leader>', ':lua SubstitutePairChars()<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<Leader>w', ':lua SurroundWithCharWord()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>W', ':lua SurroundWithCharWORD()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>d', ':lua DeleteLastCharOfSelection()<CR>', { noremap = true, silent = true })
