vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        -- Example: Enable completion triggered by <c-x><c-o>
        vim.bo[args.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Example Keymaps
        local opts = { buffer = args.buf }
        -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    end,
})


-- 1. (Optional) Configure capabilities for nvim-cmp
-- If you use nvim-cmp, you still need to merge capabilities manually for now,
-- or rely on Neovim's defaults if they are sufficient.
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- If you have installed 'cmp_nvim_lsp':
-- capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- 2. Define the Pyright configuration
-- You use vim.lsp.config() to store settings/on_attach/capabilities
vim.lsp.config('pyright', {
    capabilities = capabilities,
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = 'workspace', -- 'openFilesOnly' or 'workspace'
            }
        }
    }
})

-- 3. Enable Pyright
-- This replaces the old .setup({}) call.
-- It tells Neovim to activate the server for python files.
vim.lsp.enable('pyright')
