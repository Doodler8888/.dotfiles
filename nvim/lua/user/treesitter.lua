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

-- Define universal modifier keys
local modifier = vim.fn.has('mac') == 1 and '<D-' or '<A-'
local ctrl_modifier = vim.fn.has('mac') == 1 and '<C-D-' or '<C-M-'

-- Jump to start of function (normal, visual, and operator-pending modes)
vim.keymap.set({'n', 'v', 'o'}, ctrl_modifier .. 'a>', function()
    print("Jumping to start of function")
    vim.cmd("TSTextobjectGotoPreviousStart @function.outer")
end, { noremap = true, silent = false, desc = "Jump to start of function" })

-- Jump to end of function (normal, visual, and operator-pending modes)
vim.keymap.set({'n', 'v', 'o'}, ctrl_modifier .. 'e>', function()
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


vim.filetype.add({
  extension = {
    conf = function(path, bufnr)
      -- Check if it's in an nginx directory or has nginx-like content
      if path:match("nginx") then
        return "nginx"
      end
      return "conf"
    end,
  },
  pattern = {
    [".*/nginx/.*%.conf"] = "nginx",
    [".*/sites-available/.*"] = "nginx",
    [".*/sites-enabled/.*"] = "nginx",
  },
})

local RemoveComments = function()
    local ts         = vim.treesitter
    local bufnr      = vim.api.nvim_get_current_buf()
    local ft         = vim.bo[bufnr].filetype
    local lang       = ts.language.get_lang(ft) or ft

    local ok, parser = pcall(ts.get_parser, bufnr, lang)
    if not ok then return vim.notify("No parser for " .. ft, vim.log.levels.WARN) end

    local tree   = parser:parse()[1]
    local root   = tree:root()
    local query  = ts.query.parse(lang, "(comment) @comment")

    local ranges = {}
    for _, node in query:iter_captures(root, bufnr, 0, -1) do
        table.insert(ranges, { node:range() })
    end

    table.sort(ranges, function(a, b)
        if a[1] == b[1] then return a[2] < b[2] end
        return a[1] > b[1]
    end)

    for _, r in ipairs(ranges) do
        vim.api.nvim_buf_set_text(bufnr, r[1], r[2], r[3], r[4], {})
    end
end
vim.api.nvim_create_user_command("RemoveComments", RemoveComments, {})
