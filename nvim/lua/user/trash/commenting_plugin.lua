require('Comment').setup({
    pre_hook = function(ctx)
	if vim.bo.filetype == 'helm' then
	    return vim.bo.commentstring
	end
    end,
})
