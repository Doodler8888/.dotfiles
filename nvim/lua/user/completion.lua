vim.cmd([[ set wildmode=longest:full ]])
vim.opt.completeopt = { "menuone", "noselect", "popup", "fuzzy" }


vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspCompletion", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf

    -- Check if the attached server actually supports completion
    if client and client.supports_method("textDocument/completion") then

      -- Enable the built-in logic
      vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })

    end
  end,
})

-- This sets the autocompletion to be unconditional
-- vim.api.nvim_create_autocmd("InsertCharPre", {
--   callback = function()
--     vim.lsp.completion.get()
--   end,
-- })
