---@type vim.lsp.Config
return {
    cmd = { "pyright" },
    root_markers = { ".venv", ".git" },
    filetypes = { "python" },
}
