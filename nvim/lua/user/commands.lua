vim.cmd('command! Bsh lcd $HOME/.dotfiles/bash | edit .bashrc')
vim.cmd('command! Inpt lcd $HOME/.dotfiles/bash | edit .inputrc')
vim.cmd('command! Nvm lcd $HOME/.dotfiles/nvim | edit init.lua')
vim.cmd('command! Zsh lcd $HOME/.dotfiles/zsh | edit .zshrc')
vim.cmd('command! SZsh lcd $HOME/.secret_dotfiles/zsh | edit .zshrc')
vim.cmd('command! Bsh lcd $HOME/.dotfiles/bash | edit .bashrc')
vim.cmd('command! Emc lcd $HOME/.emacs.d | edit config.org')
vim.cmd('command! Zlj lcd $HOME/.dotfiles/zellij | edit config.kdl')
vim.cmd('command! Nu lcd $HOME/.dotfiles/nu | edit config.nu')
vim.cmd('command! Hosts lcd /etc/ansible | edit hosts')
vim.cmd('command! Books lcd $HOME/Downloads/books | Oil ~/Downloads/books')
vim.cmd('command! Home lcd $HOME/Downloads/books | Oil ~/')
-- vim.cmd('command! Books lcd $HOME/.secret_dotfiles/ansible/playbooks')
vim.cmd('command! Keys lcd $HOME/.secret_dotfiles/zsh | edit keys.sh')
vim.cmd('command! Str lcd $HOME/.dotfiles/starship/ | edit starship.toml')
vim.cmd('command! Scr lcd $HOME/.dotfiles/scripts | Oil ~/.dotfiles/scripts')
vim.cmd('command! Raku lcd $HOME/.dotfiles/scripts/raku/ | Oil ~/.dotfiles/scripts/raku/')
vim.cmd('command! Dot lcd $HOME/.dotfiles/ | Oil ~/.dotfiles/')
vim.cmd('command! SDot lcd $HOME/.secret_dotfiles/ | Oil ~/.secret_dotfiles/')
vim.cmd('command! Alc lcd $HOME/.dotfiles/alacritty/ | edit alacritty.toml')
vim.cmd('command! Sway lcd $HOME/.dotfiles/alacritty/ | Oil ~/.dotfiles/sway')
vim.cmd('command! H lcd $HOME/ | Oil ~/')


-- Current filetype
vim.api.nvim_create_user_command('FT', function()
    print(vim.bo.filetype)
end, {})

