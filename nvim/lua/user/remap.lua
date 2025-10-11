vim.g.mapleader = " "
vim.keymap.set("n", "<leader>fe", vim.cmd.Ex)

-- Define universal modifier keys at the top
local modifier = vim.fn.has('mac') == 1 and '<D-' or '<A-'
local ctrl_modifier = vim.fn.has('mac') == 1 and '<C-D-' or '<C-M-'

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
-- Keep center view
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-f>", "<C-f>zz")
vim.keymap.set("n", "<C-b>", "<C-b>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Make a file executable
vim.keymap.set("n", "<leader>xx", "<cmd>!chmod +x %<CR>", { silent = true })

-- Disable Control+c
vim.api.nvim_set_keymap('n', '<C-c>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-c>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-c>', '<Nop>', { noremap = true, silent = true })

-- Quit the terminal mode (but not the terminal emulation)
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', {noremap = true})

-- Toggle colorcolumn
vim.cmd('command! Column execute "set colorcolumn=" . (&colorcolumn == "" ? "80" : "")')

-- Keep selection and indent left and right in visual mode
vim.api.nvim_set_keymap('v', '>', '>gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<', '<gv', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<C-t>', '<cmd>:wqa<CR>', { noremap = true, silent = true })

-- Insert Mode Bindings
vim.keymap.set('i', '<C-f>', '<Right>', {noremap = true})
vim.keymap.set('i', '<C-n>', '<Down>', {noremap = true})
vim.keymap.set('i', '<C-b>', '<Left>', {noremap = true})
vim.keymap.set('i', '<C-p>', '<Up>', {noremap = true})
vim.keymap.set('i', '<C-a>', '<Home>', {noremap = true})  -- Start of line
vim.keymap.set('i', '<C-e>', '<End>', {noremap = true})   -- End of line
vim.keymap.set('i', modifier .. 'f>', '<Esc>ea', {noremap = true})
vim.keymap.set('i', ctrl_modifier .. 'f>', '<Esc>Ea', {noremap = true})
vim.keymap.set('i', ctrl_modifier .. 'b>', '<C-o>B', {noremap = true})
vim.keymap.set('i', modifier .. 'b>', '<C-o>b', {noremap = true})
vim.keymap.set('i', modifier .. 'm>', '<Esc>I', {noremap = true})
vim.keymap.set('i', '<M-d>', '<C-o>dw', { desc = 'Delete word forward' })
vim.keymap.set('i', '<M-)>', '<C-o>)', { desc = 'Move to next sentence' })
vim.keymap.set('i', '<M-(>', '<C-o>(', { desc = 'Move to previous sentence' })

-- Normal/Operator-Pending Mode Bindings
vim.keymap.set({'n', 'o'}, modifier .. 'm>', '^')
vim.keymap.set('n', '<CR>', 'i<CR><Esc>', { noremap = true })

-- Cmd line bindings
vim.keymap.set('c', '<C-f>', '<Right>')
vim.keymap.set('c', '<C-b>', '<Left>')
vim.keymap.set('c', '<C-q>', 'q:<CR>')
vim.keymap.set('c', '<C-k>', '<C-\\>e(strpart(getcmdline(), 0, getcmdpos() - 1))<CR>')
vim.keymap.set('c', '<C-y>', '<C-r>+', { noremap = true })
vim.keymap.set('c', '<C-e>', '<End>', { noremap = true })
vim.keymap.set('c', '<C-a>', '<Home>', { noremap = true })
vim.keymap.set('c', ctrl_modifier .. 'f>', '<S-Right>', { noremap = true })
vim.keymap.set('c', ctrl_modifier .. 'b>', '<S-Left>', { noremap = true })

vim.keymap.set('c', '<C-q>', function()
    if vim.fn.getcmdtype() == ':' then
        vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes('<C-F>', true, true, true),
            'n', true
        )
        return ''
    end
end, { expr = true })

vim.keymap.set('c', modifier .. 'f>', function()
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

vim.keymap.set('c', modifier .. 'b>', function()
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
    return ""
  else
    return vim.api.nvim_replace_termcodes('<C-o>D', true, true, true)
  end
end
vim.keymap.set('i', '<C-k>', emacs_kill_line, { noremap = true, expr = true })

-- Create a new tab
vim.api.nvim_set_keymap('n', '<Leader>tn', ':tabnew<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>tx', ':tabclose<CR>', {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<Leader>cc', ':Cp<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>cf', ':Cpf<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>cr', ':Cpr<CR>', {noremap = true, silent = true})

-- Tables
vim.api.nvim_set_keymap('n', '<Leader>te', ':TableModeToggleeCR>', {noremap = true, silent = true})

-- Move between tabs with
for i = 1, 9 do
  local lhs = modifier .. i .. '>'
  local rhs = i .. 'gt'
  local opts = { noremap = true, silent = true, desc = "Go to tab " .. i }
  vim.keymap.set('n', lhs, rhs, opts)
end

-- Remove traling spaces
vim.api.nvim_set_keymap('n', '<leader>rw', [[:%s/\s\+$//e<CR>]], {noremap = true, silent = true})

-- Remove persistent highliting after pattern matching actions
vim.api.nvim_set_keymap('n', '<Esc><Esc>', ':noh<CR><Esc>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<Leader>uu', ':UndotreeToggle<CR>', {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<C-w>y', '<Cmd>wincmd t<Bar>wincmd l<CR>', { noremap = true, silent = true })

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
  local lines = vim.split(clip, "\n", true)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local current_line = vim.api.nvim_get_current_line()

  if #lines == 1 then
    local new_line = current_line:sub(1, col) .. lines[1] .. current_line:sub(col+1)
    vim.api.nvim_set_current_line(new_line)
    vim.api.nvim_win_set_cursor(0, { row, col + #lines[1] })
  else
    local first_line = current_line:sub(1, col) .. lines[1]
    local last_line  = lines[#lines] .. current_line:sub(col+1)
    local new_lines = { first_line }
    if #lines > 2 then
      for i = 2, #lines - 1 do
        table.insert(new_lines, lines[i])
      end
    end
    table.insert(new_lines, last_line)
    vim.api.nvim_buf_set_lines(0, row - 1, row, false, new_lines)
    vim.api.nvim_win_set_cursor(0, { row + #lines - 1, #lines[#lines] })
  end
end
vim.keymap.set('i', '<C-y>', function()
  paste_clipboard()
end, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>ww', function()
  if vim.bo.filetype == 'oil' then
    vim.cmd('write')
    return
  end
  local dir = vim.fn.expand('%:h')
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, 'p')
  end
  vim.cmd('write')
end, {noremap = true, silent = true})

vim.keymap.set('n', '<leader>qa', ':wqa<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<leader>wa', ':wa<CR>', {noremap = true, silent = true})

vim.keymap.set('n', '<leader>so', function()
  local cfg = vim.fn.stdpath('config') .. '/init.lua'
  local ok, err = pcall(vim.cmd, 'source ' .. cfg)
  if ok then
    vim.notify('✨ Config reloaded!', vim.log.levels.INFO)
  else
    vim.notify('❌ Error reloading config:\n' .. tostring(err), vim.log.levels.ERROR)
  end
end, { noremap = true, silent = true, desc = 'Reload config' })

vim.api.nvim_set_keymap('c', '<C-g>', '<C-c>', { noremap = true })

vim.keymap.set("n", "g;", function()
  local pos_before = vim.api.nvim_win_get_cursor(0)
  vim.cmd("normal! g;")
  local pos_after = vim.api.nvim_win_get_cursor(0)
  if pos_before[1] == pos_after[1] and pos_before[2] == pos_after[2] then
    vim.cmd("normal! g;")
  end
end, { noremap = true, silent = true })

-- saosietn test123 aorisetn
