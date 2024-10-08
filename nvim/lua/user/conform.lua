-- At a minimum, you will need to set up some formatters by filetype

require("conform").setup({
	formatters_by_ft = {
		-- lua = { "stylua" },
		rust = { "rustfmt" },
		go = { "gofmt" },
		python = { "black" },
	},
})

-- -- Then you can use conform.format() just like you would vim.lsp.buf.format(). For example, to format on save:
-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	pattern = "*",
-- 	callback = function(args)
-- 		require("conform").format({ bufnr = args.buf })
-- 	end,
-- })

-- -- As a shortcut, conform will optionally set up this format-on-save autocmd for you
-- require("conform").setup({
-- 	format_on_save = {
-- 		-- These options will be passed to conform.format()
-- 		timeout_ms = 500,
-- 		lsp_fallback = true,
-- 	},
-- })

vim.api.nvim_create_user_command("F", function()
	require("conform").format()
end, {})
