require('lint').linters_by_ft = {
  -- markdown = {'vale',}
  ['yaml.ansible'] = {'ansible_lint',},
  -- dockerfile = {'hadolint',},
  sh = {'shellcheck',},
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()

    -- try_lint without arguments runs the linters defined in `linters_by_ft`
    -- for the current filetype
    require("lint").try_lint()

    -- -- You can call `try_lint` with a linter name or a list of names to always
    -- -- run specific linters, independent of the `linters_by_ft` configuration
    -- require("lint").try_lint("cspell")
  end,
})

-- Lint on opening a file
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  callback = function()
    require("lint").try_lint()
  end,
})

-- -- Lint after pasting
-- vim.api.nvim_create_autocmd({ "TextChangedP" }, {
--   callback = function()
--     require("lint").try_lint()
--   end,
-- })
--
-- -- Lint on leaving the insert mode
-- vim.api.nvim_create_autocmd({ "InsertLeave" }, {
--   callback = function()
--     require("lint").try_lint()
--   end,
-- })
--
-- -- Lint on text change
-- vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
--   callback = function()
--     require("lint").try_lint()
--   end,
-- })
