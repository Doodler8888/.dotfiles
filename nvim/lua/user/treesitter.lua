require 'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    ensure_installed = { "terraform", "hcl", "vim", "vimdoc", "query", "go", "yaml", "gotmpl" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true, -- I disabled it, because it overcomplicates things.

    ignore_install = { "helm", "gotmpl" },

    highlight = {
        enable = true,
        disable = { "lua", "tmux", "csv", "lisp", "commonlisp" }, -- commonlisp is triggered in elisp files
        additional_vim_regex_highlighting = false,
    },
    textobjects = {
        select = {
            enable = true,
            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
		["af"] = "@function.outer",
		["if"] = "@function.inner",
		["at"] = "@class.outer",
		["it"] = "@class.inner",
		["al"] = "@loop.outer",
		["il"] = "@loop.inner",
		["ae"] = "@parameter.outer",
		["ie"] = "@parameter.inner",
		["ar"] = "@return.outer",
		["ir"] = "@return.inner",
		["ac"] = "@conditional.outer",
		["ic"] = "@conditional.inner",
		["am"] = "@comment.outer",
		["im"] = "@comment.inner",
		["aa"] = "@attribute.outer",
		["ia"] = "@attribute.inner",
                -- ["ab"] = "@block.outer",
                -- ["ib"] = "@block.inner",
            },
            -- swap = {
            --
            -- }
            --      move = {
            -- enable = true,
            -- set_jumps = true,
            -- goto_next_start = {
            -- 	[']m'] = '@function.outer',
            -- 	[']]'] = '@class.outer',
            -- },
            -- goto_next_end = {
            -- 	[']M'] = '@function.outer',
            -- 	[']['] = '@class.outer',
            -- },
            --      }
        },
    },

    -- indent = {
    --   enable = true,
    -- },
}

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

parser_config.hypr = {
    install_info = {
        url = "https://github.com/luckasRanarison/tree-sitter-hypr",
        files = { "src/parser.c" },
        branch = "master",
    },
    filetype = "hypr",
}

-- parser_config.nu = {
--   install_info = {
--     url = "https://github.com/nushell/tree-sitter-nu",
--     files = { "src/parser.c" },
--     branch = "main",
--   },
--   filetype = "nu",
-- }

-- Treesitter for terraform doesn't provide highlighting for tfvars files.
vim.treesitter.language.register('terraform', { 'terraform', 'terraform-vars' })


-- Jump to start of function (normal, visual, and operator-pending modes)
vim.keymap.set({'n', 'v', 'o'}, '<C-M-a>', function()
    print("Jumping to start of function")
    vim.cmd("TSTextobjectGotoPreviousStart @function.outer")
end, { noremap = true, silent = false, desc = "Jump to start of function" })


-- Jump to end of function (normal, visual, and operator-pending modes)
vim.keymap.set({'n', 'v', 'o'}, '<C-M-e>', function()
    print("Jumping to end of function")
    vim.cmd("TSTextobjectGotoNextEnd @function.outer")
end, { noremap = true, silent = false, desc = "Jump to end of function" })


-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "yaml",
--   callback = function(args)
--     local fname = vim.api.nvim_buf_get_name(args.buf)
--     if fname:match("templates") then
--       vim.bo[args.buf].filetype = "helm"
--     end
--   end,
-- })

