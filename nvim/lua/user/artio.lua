require("vim._extui").enable({ enable = true, msg = { target = "msg" } })

local artio = require("artio")
local session = require("user.session")

local function maximize_preview(view)
  local preview_height = vim.o.lines - view.win.height - 2

  return {
    row = 0,
    col = 0,
    width = vim.o.columns,
    height = math.max(1, preview_height),
    relative = "editor",
    border = "single",
  }
end

artio.setup({
  opts = {
    preselect = true,
    bottom = true,
    shrink = false,
    promptprefix = "",
    prompt_title = true,
    pointer = "",
    use_icons = false,
  },
  win = {
    height = 12,
    hidestatusline = false,
  },
  mappings = {
    ["<c-n>"] = "down",
    ["<c-p>"] = "up",
    ["<cr>"] = "accept",
    ["<c-g>"] = "cancel",
    ["<tab>"] = "mark",
    ["<c-l>"] = "togglepreview",
    ["<c-q>"] = "setqflist",
    ["<m-q>"] = "setqflistmark",
  },
})

-- Override built-in ui select
vim.ui.select = artio.select

-- Smart Picker
vim.keymap.set("n", "<leader>ff", function()
  require("artio.builtins").smart({
    win = {
      preview_opts = maximize_preview
    }
  })
end)

-- Grep Picker
vim.keymap.set("n", "<leader>fs", function()
  require("artio.builtins").grep({
    win = {
      preview_opts = maximize_preview
    }
  })
end)

-- 4. Your Session Pickers (Unchanged)
local function session_picker()
  local sessions = session.list()
  if #sessions == 0 then
    vim.notify("No sessions found", vim.log.levels.INFO)
    return
  end

  artio.generic(sessions, {
    prompt = "Load Session",
    preview_item = function(name)
      local path = session.session_path(name)
      return vim.fn.bufadd(path)
    end,
    hl_item = function(item)
      if item.v == vim.g.current_session_name then
        return { { { 0, #item.text }, "DiagnosticHint" } }
      end
    end,
    fn = artio.mergesorters("base", artio.sorter, function(items)
        return vim.iter(items):map(function(it)
            if it.text == vim.g.current_session_name then return { it.id, {}, 100 } end
          end):totable()
      end),
    win = {
      preview_opts = function(view)
        return {
          height = math.floor(vim.o.lines * 0.85),
          row = math.floor(vim.o.lines * 0.15),
        }
      end,
    },
    on_close = function(name)
      if not name then return end
      vim.schedule(function() session.load(name) end)
    end,
  })
end

vim.keymap.set("n", "<leader>sl", session_picker)

local function delete_session_picker()
  local sessions = session.list()
  if #sessions == 0 then
    vim.notify("No sessions found", vim.log.levels.INFO)
    return
  end

  artio.generic(sessions, {
    prompt = "Delete Session",
    preview_item = function(name)
      local path = session.session_path(name)
      return vim.fn.bufadd(path)
    end,
    hl_item = function(item)
      if item.v == vim.g.current_session_name then
        return { { { 0, #item.text }, "DiagnosticWarn" } }
      end
    end,
    on_close = function(name)
      if not name then return end
      vim.schedule(function()
        local ok = vim.fn.confirm("Delete session '" .. name .. "'?", "&Yes\n&No", 2)
        if ok == 1 then
          session.delete(name)
          vim.notify("Deleted session: " .. name)
        end
      end)
    end,
  })
end

vim.keymap.set("n", "<leader>sd", delete_session_picker)
