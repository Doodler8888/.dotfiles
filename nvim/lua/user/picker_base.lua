-- lua/artio/picker_base.lua
local M = {}

-- дефолтные размеры preview
local DEFAULT_PREVIEW = {
  width_ratio = 0.6,
  height_ratio = 0.9,
}

function M.make(opts)
  opts = opts or {}

  opts.win = opts.win or {}

  -- preview включён сразу
  opts.win.preview = opts.win.preview ~= false

  -- единое место настройки preview
  opts.win.preview_opts = opts.win.preview_opts or function(view)
    local columns = vim.o.columns
    local lines = vim.o.lines

    local width = math.floor(columns * DEFAULT_PREVIEW.width_ratio)
    local height = math.floor(view.win.height * DEFAULT_PREVIEW.height_ratio)

    return {
      relative = "editor",
      width = width,
      height = height,
      col = columns - width,
      row = lines - height - vim.o.cmdheight - 2,
      border = "single",
    }
  end

  return opts
end

return M
