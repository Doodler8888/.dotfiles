local lspconfig = require('lspconfig')


vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
-- vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, { noremap = true, silent = true })


-- Lua

lspconfig.lua_ls.setup{
   cmd = { "lua-language-server" },
   settings = {
       Lua = {
           runtime = {
               version = 'LuaJIT',
               path = vim.split(package.path, ';'),
           },
           diagnostics = {
               globals = {'vim', 'opts'},
           },
           workspace = {
               library = {
                  [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                  [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
               },
           },
       },
   },
}


-- Haskell

lspconfig.hls.setup{
    cmd = { "haskell-language-server-wrapper", "--lsp" },
    -- on_attach = function(client, bufnr)
    --     local function BufSetOption(...) vim.api.nvim_buf_set_option(bufnr, ...) end
    --     -- Enable completion triggered by <c-x><c-o>
    --     BufSetOption('omnifunc', 'v:lua.vim.lsp.omnifunc')
    -- end,
    flags = {
        debounce_text_changes = 150,
    },
    -- settings = {
    --     languageServerHaskell = {
    --         formattingProvider = "ormolu"  -- or "stylish-haskell", "brittany", etc.
    --     }
    -- }
}


-- Ansible/Yaml

vim.api.nvim_create_augroup("YAMLConfig", { clear = true })

vim.api.nvim_create_autocmd("BufRead", {
    group = "YAMLConfig",
    pattern = "*.yaml",
    callback = function()
        local filename = vim.fn.expand("%:t")
        if not string.match(filename, "-playbook.yaml$") then
            -- Replace 'ansiblels' with the correct name if different
            vim.cmd("LspStop 1 (ansiblels)")
        end
    end,
})

lspconfig.ansiblels.setup{
    filetypes = { "yaml" },
    on_attach = function(client, bufnr)
        local function BufSetOption(...) vim.api.nvim_buf_set_option(bufnr, ...) end
        -- Enable completion triggered by <c-x><c-o>
        BufSetOption('omnifunc', 'v:lua.vim.lsp.omnifunc')
    end,
    flags = {
        debounce_text_changes = 150,
    }
}

lspconfig.yamlls.setup{
    settings = {
        yaml = {
            schemas = {
                -- kubernetes = "/*.yaml",
		["https://json.schemastore.org/github-workflow.json"] = ".github/workflows/*.yaml",
            },
        },
    },
}


-- Nushell

vim.api.nvim_create_autocmd("FileType", { -- Had an unexpected behavior with the custom nu type, where the autoformatiing was getting triggered on the 80th character.
  pattern = "nu",
  callback = function()
    -- Remove 't' from formatoptions to prevent auto text wrapping while typing
    vim.opt_local.formatoptions:remove("t")
  end,
})

vim.cmd [[
  autocmd BufNewFile,BufRead *.nu setfiletype nu
]]

lspconfig.nushell.setup{
  cmd = { "nu", "--lsp" },
  filetypes = { "nu" },
  single_file_support = true,
  -- root_dir = util.find_git_ancestor,
}


-- Terraform

-- vim.api.nvim_exec([[
--   autocmd BufNewFile,BufRead *.tf setfiletype terraform
-- ]], false)


lspconfig.terraformls.setup{
    filetype = { "tf", "terraform"}
}


-- Perl

-- lspconfig.perlnavigator.setup{
--     settings = {
--       perlnavigator = {
--           perlPath = 'perl',
--           enableWarnings = true,
--           perltidyProfile = '',
--           perlcriticProfile = '',
--           perlcriticEnabled = true,
--       }
--     }
-- }
