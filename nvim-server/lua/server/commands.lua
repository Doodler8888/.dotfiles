-- Open netrw in specific directories
-- vim.cmd('command! Dot Oil ~/.dotfiles')
-- vim.cmd('command! Symbols Oil /usr/share/X11/xkb/symbols')
-- vim.cmd('command! Bash Oil ~/.dotfiles/bash')
-- vim.cmd('command! Nvim Oil ~/.dotfiles/nvim')
-- vim.cmd('command! Emacs Oil ~/.emacs.d/')
-- vim.cmd('command! Home Oil ~/')

-- Open specific files
vim.cmd('command! Bsh cd $HOME/.dotfiles/bash | edit .bashrc')
-- vim.cmd('command! Inpt cd $HOME/.dotfiles/bash | edit .inputrc')
vim.cmd('command! Nvm cd $HOME/.dotfiles/nvim | edit init.lua')
vim.cmd('command! Zsh cd $HOME/.dotfiles/zsh | edit .zshrc')
vim.cmd('command! Bsh cd $HOME/.dotfiles/bash | edit .bashrc')
vim.cmd('command! Emc cd $HOME/.emacs.d | edit config.org')
vim.cmd('command! Zlj cd $HOME/.dotfiles/zellij | edit config.kdl')
vim.cmd('command! Nu cd $HOME/.dotfiles/nu | edit config.nu')
vim.cmd('command! Hosts cd /etc/ansible | edit hosts')
vim.cmd('command! Books cd $HOME/.secret_dotfiles/ansible/playbooks')
vim.cmd('command! Books cd $HOME/.secret_dotfiles/zsh | edit keys.sh')
vim.cmd('command! Str cd $HOME/.dotfiles/starship/ | edit starship.toml')

