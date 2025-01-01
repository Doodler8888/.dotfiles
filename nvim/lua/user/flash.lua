require('flash').setup {
	--    -- highlight_matches_on_search_start = false,
	--    -- only_search = true,
	--    -- keys = {
	--    --     search_activate = { '/', '?' },
	--    -- },
	   modes = {
	     char = {
	enabled = false
	     },
	--      search = {
	-- enabled = false
	--      }
	   }
}

-- vim.api.nvim_set_keymap('n', '\\', '<cmd>lua require("flash").jump({mode = "search"})<CR>', {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('v', '\\', '<cmd>lua require("flash").jump({mode = "search"})<CR>', {noremap = true, silent = true})

-- vim.api.nvim_set_keymap('n', '/', '<cmd>lua require("flash").jump()<CR>', {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('v', '/', '<cmd>lua require("flash").jump()<CR>', {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('o', '/', '<cmd>lua require("flash").jump()<CR>', {noremap = true, silent = true})


local function flash_search()
    local flash = require("flash")

    -- Create a new state
    local state = flash.jump({
        search = {
            mode = function(pattern)
                -- Store the pattern for later use
                if pattern and pattern ~= "" then
                    vim.fn.histadd('/', pattern)
                    vim.fn.setreg('/', pattern)
                    vim.v.hlsearch = 1
                end
                return pattern
            end
        }
    })
end

-- Set up the keymaps
vim.keymap.set('n', '/', flash_search, { noremap = true })
vim.keymap.set('v', '/', flash_search, { noremap = true })
vim.keymap.set('o', '/', flash_search, { noremap = true })
