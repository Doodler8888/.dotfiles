vim.api.nvim_set_hl(0, "YamlKey", { fg = "blue", bold = true })
vim.api.nvim_set_hl(0, "YamlTemplateVar", { fg = "purple", italic = true })

vim.cmd [[
  syntax match YamlKey "^[ \t]*\zs.*\ze:"
  syntax match YamlTemplateVar "{{[^}]*}}"

  highlight link YamlKey yamlKeyFace
  highlight link YamlTemplateVar yamlTemplateVarFace
]]

vim.filetype.add({
  extension = {
    yaml = "myyaml",
    yml = "myyaml"
  }
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "myyaml",
  callback = function()
    vim.bo.commentstring = "# %s"
  end,
})
