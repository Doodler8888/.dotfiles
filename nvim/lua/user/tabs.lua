-- [nfnl] Compiled from lua/user/tabs.fnl by https://github.com/Olical/nfnl, do not edit.
_G.custom_tab_name = {}
local function set_tabname()
  local tabnr = vim.api.nvim_get_current_tabpage()
  local function _1_(name)
    if name then
      _G.custom_tab_names[tabnr] = name
      return vim.cmd("redrawtabline")
    else
      return nil
    end
  end
  return vim.ui.input({prompt = "Tab name: "}, _1_)
end
print(vim.api.nvim_list_tabpages())
for other, tab_number in ipairs(vim.api.nvim_list_tabpages()) do
  print(other, tab_number)
end
return print(vim.api.nvim_get_current_tabpage())
