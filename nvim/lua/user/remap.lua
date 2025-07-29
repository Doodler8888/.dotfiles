vim.g.mapleader = " "
vim.keymap.set("n", "<leader>fe", vim.cmd.Ex)
-- vim.keymap.set("n", "<leader>fe", "<cmd>Dirvish<CR>")
-- vim.keymap.set("n", "<leader>fe", function()
--   require("mini.files").open(vim.fn.expand('%:p:h'))
-- end, { noremap = true, silent = true })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
-- Keep center view
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-f>", "<C-f>zz")
vim.keymap.set("n", "<C-b>", "<C-b>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Start replacing the word that you was on
-- vim.keymap.set("n", "<leader>rr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Make a file executable
vim.keymap.set("n", "<leader>xx", "<cmd>!chmod +x %<CR>", { silent = true })

-- Buffers
-- vim.keymap.set("n", '<S-Tab>', ":b#<CR>")
-- vim.keymap.set("n", '<C-Tab>', ":b#<CR>")
-- vim.keymap.set("n", "<C-Tab>", ":bprevious<CR>", { noremap = true, silent = true })
-- vim.keymap.set("n", "<S-Tab>", ":bnext<CR>", { noremap = true, silent = true })
-- vim.keymap.set("n", "<C-Tab>", ":BufferHistoryBack<CR>", { noremap = true, silent = true })
-- vim.keymap.set("n", "<S-Tab>", ":BufferHistoryForward<CR>", { noremap = true, silent = true })

-- Disable Control+c
vim.api.nvim_set_keymap('n', '<C-c>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-c>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-c>', '<Nop>', { noremap = true, silent = true })

-- vim.api.nvim_set_keymap('n', '<Leader>fd', ':find ', {noremap = true})

-- Quit the terminal mode (but not the terminal emulation)
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', {noremap = true})

-- vim.api.nvim_set_keymap('i', '<S-Tab>', [[<C-\><C-o>:normal! 4X<CR>]], { noremap = true, silent = true })

-- Toggle colorcolumn
      vim.cmd('command! Column execute "set colorcolumn=" . (&colorcolumn == "" ? "80" : "")')

-- Keep selection and indent left and right in visual mode
vim.api.nvim_set_keymap('v', '>', '>gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<', '<gv', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<C-t>', '<cmd>:qa!<CR>', { noremap = true, silent = true })

vim.keymap.set('i', '<C-f>', '<Right>', {noremap = true})
vim.keymap.set('i', '<C-n>', '<Down>', {noremap = true})
vim.keymap.set('i', '<C-b>', '<Left>', {noremap = true})
vim.keymap.set('i', '<C-p>', '<Up>', {noremap = true})
vim.keymap.set('i', '<C-a>', '<Home>', {noremap = true})  -- Start of line
vim.keymap.set('i', '<C-e>', '<End>', {noremap = true})   -- End of line
vim.keymap.set('i', '<M-f>', '<Esc> ea', {noremap = true})
vim.keymap.set('i', '<C-M-f>', '<Esc> Ea', {noremap = true})
vim.keymap.set('i', '<C-M-b>', '<C-o>B', {noremap = true})
vim.keymap.set('i', '<M-b>', '<C-o>b', {noremap = true})
vim.keymap.set('i', '<M-m>', '<Esc>I', {noremap = true})
vim.keymap.set({'n', 'o'}, '<M-m>', '^')
vim.keymap.set('n', '<CR>', 'i<CR><Esc>', { noremap = true })
-- vim.keymap.set('i', '<C-k>', '<Esc><Left><Left>Di', {noremap = true})

-- function _G.backword_mapping()
--   local col = vim.fn.col('.') - 1  -- Adjust for cursor at end
--   local line = vim.fn.getline('.')
--   if col > #line then
--     col = #line
--   end
--   local keys = ''
--   if col == #line then
--     keys = '<Esc><Left>Bi'
--   else
--     keys = '<Esc>Bi'
--   end
--   return vim.api.nvim_replace_termcodes(keys, true, false, true)
-- end
--
-- vim.api.nvim_set_keymap('i', '<C-M-b>', 'v:lua.backword_mapping()', {expr = true, noremap = true, silent = true})
--
-- function _G.backword_mapping_alt()
--   local col = vim.fn.col('.') - 1  -- Adjust for cursor at end
--   local line = vim.fn.getline('.')
--   if col > #line then
--     col = #line
--   end
--   local keys = ''
--   if col == #line then
--     keys = '<Esc><Left>bi'
--   else
--     keys = '<Esc>bi'
--   end
--   return vim.api.nvim_replace_termcodes(keys, true, false, true)
-- end
--
-- vim.api.nvim_set_keymap('i', '<M-b>', 'v:lua.backword_mapping_alt()', {expr = true, noremap = true, silent = true})

-- Cmd line bindings
vim.keymap.set('c', '<C-f>', '<Right>')
vim.keymap.set('c', '<C-b>', '<Left>')
vim.keymap.set('c', '<C-q>', 'q:<CR>')
vim.keymap.set('c', '<C-k>', '<C-\\>e(strpart(getcmdline(), 0, getcmdpos() - 1))<CR>')
vim.keymap.set('c', '<C-y>', '<C-r>+', { noremap = true })
vim.keymap.set('c', '<C-e>', '<End>', { noremap = true })
vim.keymap.set('c', '<C-a>', '<Home>', { noremap = true })
vim.keymap.set('c', '<C-M-f>', '<S-Right>', { noremap = true })
vim.keymap.set('c', '<C-M-b>', '<S-Left>', { noremap = true })

vim.keymap.set('c', '<C-q>', function()
    if vim.fn.getcmdtype() == ':' then
        -- Use feedkeys to trigger native behavior
        vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes('<C-F>', true, true, true),
            'n', true
        )
        return ''
    end
    -- return '<C-g>'  -- Fallback to normal C-g behavior
end, { expr = true })

vim.keymap.set('c', '<M-f>', function()
  local cmd = vim.fn.getcmdline()
  local pos = vim.fn.getcmdpos()
  local len = #cmd
  if pos > len then return end

  local function word_end_at(p)
    local word = cmd:sub(p):match("^[%w_]+")
    if word then
      return p + #word - 1
    else
      return p
    end
  end

  local target = pos
  if pos <= len and cmd:sub(pos, pos):match("[%w_]") then
    target = word_end_at(pos) + 1
  elseif pos > 1 and cmd:sub(pos - 1, pos - 1):match("[%w_]") then
    local rest = cmd:sub(pos)
    local nonword = rest:match("^[^%w_]+") or ""
    local next_word_start = pos + #nonword
    if next_word_start <= len then
      target = word_end_at(next_word_start) + 1
    end
  else
    local rest = cmd:sub(pos)
    local nonword = rest:match("^[^%w_]+") or ""
    local next_word_start = pos + #nonword
    if next_word_start <= len then
      target = word_end_at(next_word_start) + 1
    end
  end

  local steps = target - pos
  if steps > 0 then
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes("<Right>", true, false, true):rep(steps),
      'n',
      false
    )
  end
end, { noremap = true, desc = "Move forward to end of word in command mode" })

vim.keymap.set('c', '<M-b>', function()
  local cmd = vim.fn.getcmdline()
  local pos = vim.fn.getcmdpos()

  local function word_start_at(p)
    local rev_cmd = cmd:sub(1, p):reverse()
    local word = rev_cmd:match("^[%w_]+")
    if word then
      return p - #word
    else
      return p
    end
  end

  local target = pos
  if pos > 1 and cmd:sub(pos - 1, pos - 1):match("[%w_]") then
    target = word_start_at(pos - 1)
  else
    local rev_rest = cmd:sub(1, pos - 1):reverse()
    local nonword = rev_rest:match("^[^%w_]+") or ""
    local prev_word_end = pos - #nonword - 1
    if prev_word_end > 0 then
      target = word_start_at(prev_word_end)
    end
  end

  local steps = pos - target
  if steps > 0 then
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes("<Left>", true, false, true):rep(steps),
      'n',
      false
    )
  end
end, { noremap = true, desc = "Move back to start of word in command mode" })

local function emacs_kill_line()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local col = cursor[2]
  local line = vim.api.nvim_get_current_line()

  if col >= #line then
    -- At or past end-of-line: do nothing
    return ""
  else
    -- Delete from the cursor to the end of the line, staying in Insert mode.
    return vim.api.nvim_replace_termcodes('<C-o>D', true, true, true)
  end
end
vim.keymap.set('i', '<C-k>', emacs_kill_line, { noremap = true, expr = true })

-- Create a new tab
vim.api.nvim_set_keymap('n', '<Leader>tn', ':tabnew<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>tx', ':tabclose<CR>', {noremap = true, silent = true})


vim.api.nvim_set_keymap('n', '<Leader>cc', ':Cp<CR>', {noremap = true, silent = true})

-- Tables
vim.api.nvim_set_keymap('n', '<Leader>te', ':TableModeToggleeCR>', {noremap = true, silent = true})

-- Move between tabs with
for i = 1, 9 do
     -- vim.api.nvim_set_keymap('n', '<leader>'..i, i..'gt', {noremap = true, silent = true})
	 -- It's mapped to Alt
	 -- vim.api.nvim_set_keymap('n', '\27'..i, i..'gt', { noremap = true, silent = true })
	 vim.api.nvim_set_keymap('n', '<A-'..i..'>', i..'gt', { noremap = true, silent = true })
end

-- function SwitchTab(num)
--  -- Get the current number of tabs
--  local totalTabs = vim.fn.tabpagenr('$')
--  -- Check if the requested tab number is within the range of existing tabs
--  if num <= totalTabs then
--     vim.cmd('tabnext ' .. num)
--  else
--     -- Optionally, you can print a message or do nothing if the tab doesn't exist
--     -- print("Tab " .. num .. " does not exist.")
--  end
-- end
-- for i = 1, 9 do
--  vim.api.nvim_set_keymap('n', '<C-' .. i .. '>', ':lua SwitchTab(' .. i .. ')<CR>', {noremap = true, silent = true})
-- end

-- vim.api.nvim_set_keymap('n', '<Leader>ee', ':SudaWrite ', {noremap = true})

-- vim.api.nvim_set_keymap('n', '<Leader>te', ':TroubleToggle<CR>', {noremap = true})
-- vim.api.nvim_set_keymap('n', '<M-y>', ':Trouble diagnostics toggle filter.buf=0<CR>', { noremap = true, silent = true })

-- Remove traling spaces
vim.api.nvim_set_keymap('n', '<leader>rw', [[:%s/\s\+$//e<CR>]], {noremap = true, silent = true})

-- Inlay hints
-- vim.keymap.set('n', '<leader>h', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end)

-- Remove persistent highliting after pattern matching actions
vim.api.nvim_set_keymap('n', '<Esc><Esc>', ':noh<CR><Esc>', { noremap = true, silent = true })

-- -- Close a terminal buffer
-- vim.api.nvim_set_keymap('t', '<C-c><C-t>', [[<C-\><C-n>:bd!<CR>]], {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<C-c><C-b>', [[:bd!<CR>]], {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<C-c><C-e>', [[:qa!<CR>]], {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('t', '<C-w>c', '<C-\\><C-n>:q<CR>', {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<Leader>uu', ':UndotreeToggle<CR>', {noremap = true, silent = true})

-- vim.api.nvim_set_keymap('n', '<Leader>dd', ':DBUIToggle<CR>', {noremap = true, silent = true})

-- Navigate to the top-right split
vim.api.nvim_set_keymap('n', '<C-w>y', '<Cmd>wincmd t<Bar>wincmd l<CR>', { noremap = true, silent = true })
-- Navigate to the bottom-left split
-- vim.api.nvim_set_keymap('n', '<C-w>bl', '<Cmd>wincmd b<Bar>wincmd h<CR>', { noremap = true, silent = true })

-- For sway
-- vim.keymap.set('n', '<M-/>', '<Nop>', { noremap = true })

local function paste_from_clipboard()
  local reg_backup = vim.fn.getreg('"') -- Save the current unnamed register
  local reg_type_backup = vim.fn.getregtype('"')

  vim.fn.setreg('"', vim.fn.getreg('+')) -- Set unnamed register to clipboard contents
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-r>"', true, true, true), 'i', true)

  vim.fn.setreg('"', reg_backup, reg_type_backup) -- Restore unnamed register
end


-- This function pastes the system clipboard at the current cursor position in insert mode.
function _G.paste_clipboard()
  local clip = vim.fn.getreg('+')
  if clip == "" then
    return
  end
  -- Split the clipboard text into lines.
  local lines = vim.split(clip, "\n", true)
  -- Get the current cursor position (row and column; note: row is 1-indexed)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local current_line = vim.api.nvim_get_current_line()

  if #lines == 1 then
    -- For a single-line paste, simply insert the text at the cursor.
    local new_line = current_line:sub(1, col) .. lines[1] .. current_line:sub(col+1)
    vim.api.nvim_set_current_line(new_line)
    vim.api.nvim_win_set_cursor(0, { row, col + #lines[1] })
  else
    -- For a multi-line paste:
    local first_line = current_line:sub(1, col) .. lines[1]
    local last_line  = lines[#lines] .. current_line:sub(col+1)
    local new_lines = { first_line }
    -- If there are any lines in between, add them.
    if #lines > 2 then
      for i = 2, #lines - 1 do
        table.insert(new_lines, lines[i])
      end
    end
    table.insert(new_lines, last_line)
    -- Replace the current line with the new lines.
    vim.api.nvim_buf_set_lines(0, row - 1, row, false, new_lines)
    -- Move the cursor to the end of the pasted text.
    vim.api.nvim_win_set_cursor(0, { row + #lines - 1, #lines[#lines] })
  end
end
vim.keymap.set('i', '<C-y>', function()
  paste_clipboard()
end, { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('i', '<C-y>', '<C-R><C-O>+', {noremap = true, silent = true})
-- vim.cmd([[ cnoremap <C-y> <C-r>+ ]])


-- Add C-x C-s and s bindings
-- vim.api.nvim_set_keymap('n', '<C-x><C-s>', ':w<CR>', {noremap = true, silent = true})
-- vim.keymap.set('n', '<leader>ww', ':w<CR>', {noremap = true, silent = true})

vim.keymap.set('n', '<leader>ww', function()
  -- Check if current buffer is an oil buffer
  if vim.bo.filetype == 'oil' then
    vim.cmd('write')
    return
  end
  -- Original logic for non-oil buffers
  local dir = vim.fn.expand('%:h')
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, 'p')
  end
  vim.cmd('write')
end, {noremap = true, silent = true})


vim.keymap.set('n', '<leader>qa', ':wqa<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<leader>wa', ':wa<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<leader>so', ':so<CR>', {noremap = true, silent = true})

vim.api.nvim_set_keymap('c', '<C-g>', '<C-c>', { noremap = true })


-- vim.keymap.set('n', '<C-x><C-f>', function()
--     local current_path = vim.fn.fnamemodify(vim.fn.expand('%'), ':p')
--     vim.fn.feedkeys(':e ' .. current_path, 'n')
-- end, {noremap = true})


vim.keymap.set("n", "g;", function()
  local pos_before = vim.api.nvim_win_get_cursor(0)
  vim.cmd("normal! g;")
  local pos_after = vim.api.nvim_win_get_cursor(0)
  if pos_before[1] == pos_after[1] and pos_before[2] == pos_after[2] then
    vim.cmd("normal! g;")
  end
end, { noremap = true, silent = true })
