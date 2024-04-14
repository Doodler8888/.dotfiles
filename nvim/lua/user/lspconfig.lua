do
  local method = "textDocument/publishDiagnostics"
  local default_handler = vim.lsp.handlers[method]

  vim.lsp.handlers[method] = function(err, result, ctx, config)
    default_handler(err, result, ctx, config)

    if result and result.diagnostics then
      for _, v in ipairs(result.diagnostics) do
        v.bufnr = ctx.bufnr
        v.lnum = v.range.start.line + 1
        v.col = v.range.start.character + 1
        v.text = v.message
      end

      local qflist = vim.fn.getqflist({ title = 0, id = 0 })

      vim.fn.setqflist({}, qflist.title == "LSP Workspace Diagnostics" and "r" or " ", {
        title = "LSP Workspace Diagnostics",
        items = vim.diagnostic.toqflist(result.diagnostics),
      })
    end
  end
end


local lspconfig = require('lspconfig')


vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, { noremap = true, silent = true })


-- Lua

lspconfig.lua_ls.setup{
  cmd = { "lua-language-server" },
  settings = {
    Lua = {
      runtime = {
	version = 'LuaJIT',
	path = vim.split(package.path, ';'),
      },
      diagnostics = {
	globals = {'vim', 'opts'},
      },
      workspace = {
	library = {
	  [vim.fn.expand('$VIMRUNTIME/lua')] = true,
	  [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
	},
      },
    },
  },
}


-- Haskell

lspconfig.hls.setup{
    cmd = { "haskell-language-server-wrapper", "--lsp" },
    -- on_attach = function(client, bufnr)
    --     local function BufSetOption(...) vim.api.nvim_buf_set_option(bufnr, ...) end
    --     -- Enable completion triggered by <c-x><c-o>
    --     BufSetOption('omnifunc', 'v:lua.vim.lsp.omnifunc')
    -- end,
    flags = {
        debounce_text_changes = 150,
    },
    -- settings = {
    --     languageServerHaskell = {
    --         formattingProvider = "ormolu"  -- or "stylish-haskell", "brittany", etc.
    --     }
    -- }
}


-- Python

lspconfig.pyright.setup {
}


-- Ansible/Yaml

-- vim.api.nvim_create_augroup("YAMLConfig", { clear = true })
--
-- vim.api.nvim_create_autocmd("BufRead", {
--     group = "YAMLConfig",
--     pattern = "*.yaml",
--     callback = function()
--         local filename = vim.fn.expand("%:t")
--         if not string.match(filename, "-playbook.yaml$") then
--             -- Replace 'ansiblels' with the correct name if different
--             vim.cmd("LspStop 1 (ansiblels)")
--         end
--     end,
-- })

lspconfig.ansiblels.setup{
    filetypes = { "yaml.ansible" },
    on_attach = function(client, bufnr)
        local function BufSetOption(...) vim.api.nvim_buf_set_option(bufnr, ...) end
        -- Enable completion triggered by <c-x><c-o>
        BufSetOption('omnifunc', 'v:lua.vim.lsp.omnifunc')
    end,
    flags = {
        debounce_text_changes = 150,
    }
}

lspconfig.yamlls.setup{
    settings = {
        yaml = {
            schemas = {
                -- kubernetes = "/*.yaml",
		["https://json.schemastore.org/github-workflow.json"] = ".github/workflows/*.yaml",
            },
        },
    },
}
--
-- function InsertCommentChar()
--   local line = vim.api.nvim_get_current_line()
--   local cursor = vim.api.nvim_win_get_cursor(0)
--   local col = cursor[2]
--   local is_whitespace_only = line:sub(1, col):match("^%s*$") ~= nil
--
--   if is_whitespace_only then
--     -- If the line up to the cursor is only whitespace, insert `#` at the beginning
--     vim.api.nvim_set_current_line('#' .. line)
--     -- Move the cursor to the right, placing it after the inserted `#`
--     vim.api.nvim_win_set_cursor(0, {cursor[1], col + 1})
--   else
--     -- If the line contains non-whitespace characters, insert `#` with indentation
--     vim.api.nvim_input('i#')
--   end
-- end
--
-- -- Map Ctrl+O to the Lua function in insert mode for YAML files
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "yaml",
--   callback = function()
--     vim.api.nvim_buf_set_keymap(0, 'i', '<C-o>', '<Cmd>lua InsertCommentChar()<CR>', { noremap = true, silent = true })
--   end,
-- })


-- Disable auto-wrapping on specified file types

vim.api.nvim_create_autocmd("FileType", { -- Had an unexpected behavior with the custom nu type, where the autoformatiing was getting triggered on the 80th character.
  pattern = { "nu", "python" },
  callback = function()
    -- Remove 't' from formatoptions to prevent auto text wrapping while typing
    vim.opt_local.formatoptions:remove("t")
  end,
})


-- Gleam

lspconfig.gleam.setup{}


-- Nushell

vim.cmd [[
  autocmd BufNewFile,BufRead *.nu setfiletype nu
]]

lspconfig.nushell.setup{
  cmd = { "nu", "--lsp" },
  filetypes = { "nu" },
  single_file_support = true,
  -- root_dir = util.find_git_ancestor,
}


-- Terraform

-- vim.api.nvim_exec([[
--   autocmd BufNewFile,BufRead *.tf setfiletype terraform
-- ]], false)


lspconfig.terraformls.setup{
    filetype = { "tf", "terraform"}
}

-- Rust

lspconfig.rust_analyzer.setup{
    settings = {
        ["rust-analyzer"] = {
            checkOnSave = {
                command = "clippy"
            }
        }
    }
}


-- Raku

-- Define the command to start your LSP server
local cmd = { "node", "/home/wurfkreuz/.source/RakuNavigator/server/out/server.js", "--stdio" }

-- Setup the custom LSP server
lspconfig.raku_navigator.setup {
  cmd = cmd,
  filetypes = { "raku" },
  -- root_dir = lspconfig.util.root_pattern(".git", "."),
  settings = {},
}


-- Clojure

lspconfig.clojure_lsp.setup{}


-- SQL

lspconfig.sqls.setup{
  settings = {
    sqls = {
      connections = {
        {
          driver = 'postgresql',
          dataSourceName = string.format(
            "host=%s port=%s user=%s password=%s dbname=%s sslmode=disable",
            os.getenv("SHELF_DB_HOST"),
            os.getenv("SHELF_DB_PORT"),
            os.getenv("SHELF_DB_USER"),
            os.getenv("SHELF_DB_PASS"),
            os.getenv("SHELF_DB_NAME")
          )
        },
      },
    },
  },
}

