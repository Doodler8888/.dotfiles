vim.bo.shiftwidth = 2 -- Or your preferred YAML indent width
vim.bo.expandtab = true
-- Try inheriting yaml indent expression if available
-- This command might fail if yaml indent isn't loaded yet,
-- but worth trying or finding the correct indentexpr source.
vim.cmd("runtime! indent/yaml.vim")
vim.bo.indentexpr = vim.bo.indentexpr -- Re-assign yaml's indentexpr if loaded
