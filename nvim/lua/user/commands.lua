vim.cmd('command! Bsh lcd $HOME/.dotfiles/bash | edit .bashrc')
vim.cmd('command! Inpt lcd $HOME/.dotfiles/bash | edit .inputrc')
vim.cmd('command! Nvm lcd $HOME/.dotfiles/nvim | edit init.lua')
-- vim.cmd('command! Zsh lcd $HOME/.dotfiles/zsh | edit .zshrc')
vim.cmd('command! Ssh lcd $HOME/.ssh | Ex ~/.ssh')
vim.cmd('command! Zsh lcd $HOME/.dotfiles/zsh | edit .zshrc')
vim.cmd('command! SZsh lcd $HOME/.secret_dotfiles/zsh | edit .zshrc')
vim.cmd('command! Bsh lcd $HOME/.dotfiles/bash | edit .bashrc')
vim.cmd('command! Emc lcd $HOME/.emacs.d | edit config.el')
vim.cmd('command! Lem lcd $HOME/.dotfiles/.lem/ | edit init.lisp')
vim.cmd('command! Zlj lcd $HOME/.dotfiles/zellij | edit config.kdl')
vim.cmd('command! Nu lcd $HOME/.dotfiles/nu | edit config.nu')
vim.cmd('command! Hosts lcd /etc/ansible | edit hosts')
vim.cmd('command! Books lcd $HOME/Downloads/books | Ex ~/Downloads/books')
vim.cmd('command! Manager lcd $HOME/.dotfiles/nix | edit home.nix')
vim.cmd('command! Home lcd $HOME/ | Ex ~/')
-- vim.cmd('command! Home lcd $HOME/.dotfiles/nix/ | edit $HOME/.dotfiles/nix/home.nix')
vim.cmd('command! Projects lcd $HOME/.projects/ | Ex ~/.projects/')
vim.cmd('command! P lcd $HOME/.projects/ | Ex ~/.projects/')
vim.cmd('command! Keys lcd $HOME/.secret_dotfiles/zsh | edit keys.sh')
vim.cmd('command! Str lcd $HOME/.dotfiles/starship/ | edit starship.toml')
vim.cmd('command! Scr lcd $HOME/.dotfiles/scripts | Ex ~/.dotfiles/scripts')
vim.cmd('command! Scripts lcd $HOME/.dotfiles/scripts | Ex ~/.dotfiles/scripts')
vim.cmd('command! Raku lcd $HOME/.dotfiles/scripts/raku/ | Ex ~/.dotfiles/scripts/raku/')
vim.cmd('command! Dot lcd $HOME/.dotfiles/ | Ex ~/.dotfiles/')
vim.cmd('command! SDot lcd $HOME/.secret_dotfiles/ | Ex ~/.secret_dotfiles/')
vim.cmd('command! Secret lcd $HOME/.secret_dotfiles/ | Ex ~/.secret_dotfiles/')
vim.cmd('command! S lcd $HOME/.secret_dotfiles/ | Ex ~/.secret_dotfiles/')
vim.cmd('command! Alc lcd $HOME/.dotfiles/alacritty/ | edit alacritty.toml')
vim.cmd('command! Sway lcd $HOME/.dotfiles/sway/ | Ex ~/.dotfiles/sway')
vim.cmd('command! D lcd $HOME/Downloads | Ex ~/Downloads')
vim.cmd('command! Navi lcd $HOME/.dotfiles/navi/ | Ex ~/.dotfiles/navi/cheats/my__cheats/')
vim.cmd('command! Config lcd $HOME/.config | Ex ~/.config')
vim.cmd('command! C lcd $HOME/.config | Ex ~/.config')
vim.cmd('command! Todo lcd $HOME/.secret_dotfiles/nvim/todo/ | edit todo.md')
vim.cmd('command! Tmux lcd /home/wurfkreuz/.dotfiles/tmux | edit .tmux.conf')


-- Current filetype
vim.api.nvim_create_user_command('FT', function()
    print(vim.bo.filetype)
end, {})

