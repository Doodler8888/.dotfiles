local M = {}

-- Save custom tab names globally
M.save_global = function()
  print("Saving custom tab names...")
  local tabnames = {}
  local tabs = vim.api.nvim_list_tabpages()

  -- Map custom tab names by their index
  for idx, tab in ipairs(tabs) do
    local name = _G.custom_tab_names[tab]
    tabnames[idx] = name
    print("Saving tab index:", idx, "Name:", name)
  end

  return { tabnames = tabnames }
end

-- Load custom tab names globally
M.load_global = function(data)
  if data and data.tabnames then
    print("Loading custom tab names...")
    local tabs = vim.api.nvim_list_tabpages()
    for idx, tab in ipairs(tabs) do
      local name = data.tabnames[idx]
      if name then
        _G.custom_tab_names[tab] = name
        print("Loading tab index:", idx, "Name:", name)
      end
    end
    vim.cmd('redrawtabline')
  end
end

return M
