vim.lsp.start({

  name = 'perlnavigator-server',
  cmd = {'perlnavigator'},
  filetypes = { "perl" },
  settings = {
    perlnavigator = {
	perlPath = 'perl',
	enableWarnings = true,
	perltidyProfile = '',
	perlcriticProfile = '',
	perlcriticEnabled = true,
    }
  }
})
