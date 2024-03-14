require('flash').setup {
    -- highlight_matches_on_search_start = false,
    -- only_search = true,
    -- keys = {
    --     search_activate = { '/', '?' },
    -- },
    modes = {
	char = {
	    enabled = false
	},
	search = {
	  enabled = false
	}
    }
}

vim.api.nvim_set_keymap('n', '\\', '<cmd>lua require("flash").jump({mode = "search"})<CR>', {noremap = true, silent = true})
