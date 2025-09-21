-- Function to create a motion with automatic visual selection
local function create_visual_motion(motion_func, adjust_selection)
  return function()
    -- Exit visual mode if we're in it
    if vim.fn.mode():match('[vV]') then
      vim.cmd('normal! v')
    end

    local start_pos = vim.fn.getpos('.')

    -- Execute the motion
    motion_func()

    local end_pos = vim.fn.getpos('.')

    -- If the cursor moved, apply visual selection
    if start_pos[2] ~= end_pos[2] or start_pos[3] ~= end_pos[3] then
      adjust_selection(start_pos, end_pos)
    end
  end
end

-- Adjustment functions for each motion
local function adjust_e(start_pos, end_pos)
  vim.fn.setpos('.', start_pos)
  vim.cmd('normal! l')
  local selection_start = vim.fn.getpos('.')
  vim.cmd('normal! v')
  vim.fn.setpos('.', end_pos)
end



local function adjust_b(start_pos, end_pos)
    -- Remove any existing selection
    vim.cmd('normal! v')

    -- Move back to the start of the previous word
    vim.fn.setpos('.', end_pos)

    -- Store this position
    local word_start = vim.fn.getpos('.')

    -- Move to the end of this word
    vim.cmd('normal! e')
    local word_end = vim.fn.getpos('.')

    -- Check if it's a single-character word
    if word_start[3] == word_end[3] then
        -- If single character, just enter visual mode
        vim.cmd('normal! v')
    else
        -- If multi-character, move to end, enter visual mode, then back to start
        vim.fn.setpos('.', word_end)
        vim.cmd('normal! v')
        vim.cmd('normal! b')
    end
end




local function adjust_B(start_pos, end_pos)
  vim.fn.setpos('.', end_pos)
  vim.cmd('normal! l')
  vim.cmd('normal! v')
  vim.fn.setpos('.', start_pos)
end

-- Define the motion functions
local function motion_e() vim.cmd('normal! e') end
local function motion_E() vim.cmd('normal! E') end
local function motion_b() vim.cmd('normal! b') end
local function motion_B() vim.cmd('normal! B') end

-- Create the visual motions
local visual_e = create_visual_motion(motion_e, adjust_e)
local visual_E = create_visual_motion(motion_E, adjust_E)
local visual_b = create_visual_motion(motion_b, adjust_b)
local visual_B = create_visual_motion(motion_B, adjust_B)

-- Rebind the keys
vim.keymap.set({'n', 'v'}, 'e', visual_e, { noremap = true, silent = true })
vim.keymap.set({'n', 'v'}, 'E', visual_E, { noremap = true, silent = true })
vim.keymap.set({'n', 'v'}, 'b', visual_b, { noremap = true, silent = true })
vim.keymap.set({'n', 'v'}, 'B', visual_B, { noremap = true, silent = true })
