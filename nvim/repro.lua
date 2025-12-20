vim.g.mapleader = " "

require("vim._extui").enable({ enable = true, msg = { target = "msg" } })

vim.pack.add({
  "https://github.com/comfysage/artio.nvim",
})

local artio = require("artio")
local session = require("user.session")

local function maximize_preview(view)
  -- view.win.height is the height of the picker window
  local picker_height = view.win.height
  local cmd_height = vim.o.cmdheight
  local total_height = vim.o.lines

  -- Calculate height: Total - Picker - Cmdline - Statusline (approx 2 lines for safety/borders)
  local preview_height = total_height - picker_height - cmd_height - 2

  return {
    row = 0,               -- Start at the very top of the screen
    col = 0,               -- Start at the very left
    width = vim.o.columns, -- Full width
    height = math.max(1, preview_height),
    relative = "editor",
    border = "single",     -- Optional: adds a border to the preview
  }
end

require("artio").setup({
  opts = {
    preselect = true, -- whether to preselect the first match
    bottom = true, -- whether to draw the prompt at the bottom
    shrink = true, -- whether the window should shrink to fit the matches
    promptprefix = "", -- prefix for the prompt
    prompt_title = true, -- whether to draw the prompt title
    pointer = "", -- pointer for the selected match
    use_icons = false, -- requires mini.icons
  },
  win = {
    height = 12,
    hidestatusline = false, -- works best with laststatus=3
    preview_opts = maximize_preview,
  },
  -- NOTE: if you override the mappings, make sure to provide keys for all actions
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

-- override built-in ui select with artio
vim.ui.select = require("artio").select

-- vim.keymap.set("n", "<leader><leader>", "<Plug>(artio-files)")
vim.keymap.set("n", "<leader>ff", function()
  require("artio.builtins").smart({
    win = {
      preview_opts = maximize_preview
    }
  })
end)

-- If you want the same for Grep (<leader>fs):
vim.keymap.set("n", "<leader>fs", function()
  require("artio.builtins").grep({
    win = {
      preview_opts = maximize_preview
    }
  })
end)

-- -- general built-in pickers
-- vim.keymap.set("n", "<leader>fh", "<Plug>(artio-helptags)")
-- vim.keymap.set("n", "<leader>fb", "<Plug>(artio-buffers)")
-- vim.keymap.set("n", "<leader>f/", "<Plug>(artio-buffergrep)")
-- vim.keymap.set("n", "<leader>fo", "<Plug>(artio-oldfiles)")


local function session_picker()
  local sessions = session.list()
  if #sessions == 0 then
    vim.notify("No sessions found", vim.log.levels.INFO)
    return
  end

  artio.generic(sessions, {
    prompt = "Load Session",

    -- A. Preview (:source preview)
    preview_item = function(name)
      local path = session.session_path(name)
      return vim.fn.bufadd(path)
    end,

    -- B. Highlight current session
    hl_item = function(item)
      if item.v == vim.g.current_session_name then
        return {
          { { 0, #item.text }, "DiagnosticHint" },
        }
      end
    end,

    -- C. Custom sorter (current session first)
    fn = artio.mergesorters(
      "base",
      artio.sorter,
      function(items)
        return vim.iter(items)
          :map(function(it)
            if it.text == vim.g.current_session_name then
              return { it.id, {}, 100 }
            end
          end)
          :totable()
      end
    ),

    on_close = function(name)
      if not name then
        return
      end
      vim.schedule(function()
        session.load(name)
      end)
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
        return {
          { { 0, #item.text }, "DiagnosticWarn" },
        }
      end
    end,

    on_close = function(name)
      if not name then
        return
      end

      vim.schedule(function()
        local ok = vim.fn.confirm(
          "Delete session '" .. name .. "'?",
          "&Yes\n&No",
          2
        )
        if ok == 1 then
          session.delete(name)
          vim.notify("Deleted session: " .. name)
        end
      end)
    end,
  })
end

vim.keymap.set("n", "<leader>sd", delete_session_picker)


------------------


-- vim.pack.add({
--   "https://github.com/simifalaye/minibuffer.nvim",
-- })
--
-- local minibuffer = require("minibuffer")
--
-- vim.ui.select = require("minibuffer.builtin.ui_select")
-- vim.ui.input = require("minibuffer.builtin.ui_input")
--
-- vim.keymap.set("n", "<M-;>", require("minibuffer.builtin.cmdline"))
-- vim.keymap.set("n", "<M-.>", function()
--   minibuffer.resume(true)
-- end)


--------------------


-- vim.g.mapleader = " "
--
-- vim.pack.add({
--   "https://github.com/nvim-lua/plenary.nvim",
--   "https://github.com/nvim-telescope/telescope.nvim",
-- })
--
-- require("telescope").setup {}
--
-- vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files)
