vim.lsp.set_log_level("debug")
-- local capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)

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


-- vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, { noremap = true, silent = true })
-- vim.keymap.set('n', 'K', vim.lsp.buf.hover, { noremap = true, silent = true })


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

-- vim.filetype.add({
--   pattern = {
--     -- Ansible Playbooks & Roles (extend as needed)
--     [".*playbook.*%.ya?ml"] = "yaml.ansible",
--     [".*/roles/.*/tasks/.*%.ya?ml"] = "yaml.ansible",
--     [".*/roles/.*/handlers/.*%.ya?ml"] = "yaml.ansible",
--     [".*/roles/.*/defaults/.*%.ya?ml"] = "yaml.ansible",
--     [".*/roles/.*/vars/.*%.ya?ml"] = "yaml.ansible",
--     [".*/roles/.*/meta/.*%.ya?ml"] = "yaml.ansible",
--     -- Additional pattern for ansible tasks outside roles:
--     [".*/ansible/.*tasks/.*%.ya?ml"] = "yaml.ansible",
--     [".*/ansible/.*hosts%.ya?ml"] = "yaml.ansible",
--     [".*/ansible/.*inventory%.ya?ml"] = "yaml.ansible",
--
--     -- Kubernetes templates
--     [".*/templates/.*%.ya?ml"] = "yaml.kubernetes",
--     [".*/templates/.*%.yaml"] = "yaml.kubernetes",
--     [".*/kubernetes/.*%.ya?ml"] = "yaml.kubernetes",
--     [".*/kubernetes/.*%.yaml"] = "yaml.kubernetes",
--   },
-- })

-- -- I've added it, because the custom filetypes aren't applied on files that end
-- -- with 'yaml'.
-- vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
--   pattern = "*kubernetes/*.yaml",
--   callback = function()
--     vim.bo.filetype = "yaml.kubernetes"
--   end,
-- })


-- require("lspconfig").yamlls.setup {
--   filetypes = { "yaml", "yaml.kubernetes", "yaml.ansible" },
--   on_attach = function(client, bufnr)
--     if vim.bo[bufnr].filetype == "yaml.kubernetes" then
--       -- Use the current file's full path to force schema association only for this file
--       local current_file = vim.fn.expand("%:p")
--       client.config.settings.yaml.schemas = {
--         -- You can replace the key below with a full schema URL if desired.
--         ["kubernetes"] = { current_file },
--       }
--       client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
--     end
--   end,
--   settings = {
--     yaml = {
--       schemas = {}, -- start empty and populate it only when needed
--     },
--   },
-- }


-- Disable because it creates '.ansible' directories everywhere
-- require('lspconfig').ansiblels.setup {
--   cmd = { "ansible-language-server", "--stdio" },
--   root_dir = lspconfig.util.root_pattern(".git"),
--   filetypes = { "yaml", "ansible" },
--   }

require("lspconfig").yamlls.setup {
	-- filetypes = { "yaml", "yaml.kubernetes", "yaml.ansible" },
	filetypes = { "yaml", "helm" },
	settings = {
	  yaml = {
	    schemas = {
	      ["https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json"] = "tasks/*.{yml,yaml}",
	      kubernetes = {
		"*/templates/*.yaml",
		"*/kubernetes/*.yaml",
		"*/templates/*.yml",
	},
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
  pattern = { "nu", "python", "terraform", "nix", "yaml", "terraform-vars", "markdown" },
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

-- Nix

-- require'lspconfig'.nil_ls.setup{}

-- SQL

-- lspconfig.sqls.setup{
--   settings = {
--     sqls = {
--       connections = {
--         {
--           driver = 'postgresql',
--           dataSourceName = "host=localhost port=5432 user=wurfkreuz password=1337 dbname=server sslmode=disable"
--         },
--       },
--     },
--   },
-- }

-- local dataSourceName = string.format(
--   "host=%s port=%s user=%s password=%s dbname=%s sslmode=disable",
--   os.getenv("SERVER_DB_HOST"),
--   os.getenv("SERVER_DB_PORT"),
--   os.getenv("SERVER_DB_USER"),
--   os.getenv("SERVER_DB_PASS"),
--   os.getenv("SERVER_DB_NAME")
-- )
--
-- print(dataSourceName)

-- lspconfig.sqls.setup{
--   settings = {
--     sqls = {
--       connections = {
--         {
--           driver = 'postgresql',
--           dataSourceName = string.format(
--             "host=%s port=%s user=%s password=%s dbname=%s sslmode=disable",
--             os.getenv("SERVER_DB_HOST"),
--             os.getenv("SERVER_DB_PORT"),
--             os.getenv("SERVER_DB_USER"),
--             os.getenv("SERVER_DB_PASS"),
--             os.getenv("SERVER_DB_NAME")
--           )
--         },
--       },
--     },
--   },
-- }

-- lspconfig.sqls.setup{
--   on_attach = function(client, bufnr)
--     require('sqls').on_attach(client, bufnr)
--   end
-- }

require 'lspconfig.configs'.fennel_language_server = {
  default_config = {
    -- replace it with true path
    cmd = {'/home/wurfkreuz/.cargo/bin/fennel-language-server'},
    filetypes = {'fennel'},
    single_file_support = true,
    -- source code resides in directory `fnl/`
    root_dir = lspconfig.util.root_pattern("fnl"),
    settings = {
      fennel = {
        workspace = {
          -- If you are using hotpot.nvim or aniseed,
          -- make the server aware of neovim runtime files.
          library = vim.api.nvim_list_runtime_paths(),
        },
        diagnostics = {
          globals = {'vim'},
        },
      },
    },
  },
}

lspconfig.fennel_language_server.setup{}

-- local config = {
--   cmd = { '/home/wurfkreuz/perl5/bin/pls' }, -- complete path to where PLS is located
--   settings = {
--     pls = {
--       -- inc = { '/my/perl/5.34/lib', '/some/other/perl/lib' },  -- add list of dirs to @INC
--       -- cwd = { '/my/projects' },   -- working directory for PLS
--       -- perlcritic = { enabled = true, perlcriticrc = '/my/projects/.perlcriticrc' },  -- use perlcritic and pass a non-default location for its config
--       perlcritic = { enabled = true, },  -- use perlcritic and pass a non-default location for its config
--       syntax = { enabled = true, perl = '/usr/bin/perl', args = { 'arg1', 'arg2' } }, -- enable syntax checking and use a non-default perl binary
--       -- perltidy = { perltidyrc = '/my/projects/.perltidyrc' } -- non-default location for perltidy's config
--       perltidy = { } -- non-default location for perltidy's config
--     }
--   }
-- }
-- lspconfig.perlpls.setup(config)
