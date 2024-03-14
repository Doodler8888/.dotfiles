vim.lsp.start({
  name = 'lua_ls',
  cmd = {'lua-language-server'},
  settings = {
    Lua = {
	runtime = {
	    version = 'LuaJIT',
	    path = vim.split(package.path, ';'),
	},
	diagnostics = {
	    globals = {'vim', 'opts'},
	},
	telemetry = {
	    enable = false,
	},
    },
},
})

