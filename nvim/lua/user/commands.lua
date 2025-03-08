vim.cmd('command! Bsh lcd $HOME/.dotfiles/bash | edit .bashrc')
vim.cmd('command! Inpt lcd $HOME/.dotfiles/bash | edit .inputrc')
vim.cmd('command! Nvm lcd $HOME/.dotfiles/nvim | edit init.lua')
-- vim.cmd('command! Zsh lcd $HOME/.dotfiles/zsh | edit .zshrc')
vim.cmd('command! Ssh lcd $HOME/.ssh | Dirvish ~/.ssh')
vim.cmd('command! Zsh lcd $HOME/.dotfiles/zsh | edit .zshrc')
vim.cmd('command! SZsh lcd $HOME/.secret_dotfiles/zsh | edit .zshrc')
vim.cmd('command! Bsh lcd $HOME/.dotfiles/bash | edit .bashrc')
vim.cmd('command! Emc lcd $HOME/.emacs.d | edit config.el')
vim.cmd('command! Lem lcd $HOME/.dotfiles/.lem/ | edit init.lisp')
vim.cmd('command! Zlj lcd $HOME/.dotfiles/zellij | edit config.kdl')
vim.cmd('command! Nu lcd $HOME/.dotfiles/nu | edit config.nu')
vim.cmd('command! Hosts lcd /etc/ansible | edit hosts')
vim.cmd('command! Books lcd $HOME/Downloads/books | Dirvish ~/Downloads/books')
vim.cmd('command! Manager lcd /home/wurfkreuz/.dotfiles/home-manager/ | edit home.nix')
vim.cmd('command! Home lcd $HOME/ | Dirvish ~/')
-- vim.cmd('command! Home lcd $HOME/.dotfiles/nix/ | edit $HOME/.dotfiles/nix/home.nix')
vim.cmd('command! Projects lcd $HOME/.projects/ | Dirvish ~/.projects/')
vim.cmd('command! P lcd $HOME/.projects/ | Dirvish ~/.projects/')
vim.cmd('command! Keys lcd $HOME/.secret_dotfiles/zsh | edit keys.sh')
vim.cmd('command! Str lcd $HOME/.dotfiles/starship/ | edit starship.toml')
vim.cmd('command! Scr lcd $HOME/.dotfiles/scripts | Dirvish ~/.dotfiles/scripts')
vim.cmd('command! Scripts lcd $HOME/.dotfiles/scripts | Dirvish ~/.dotfiles/scripts')
vim.cmd('command! Raku lcd $HOME/.dotfiles/scripts/raku/ | Dirvish ~/.dotfiles/scripts/raku/')
vim.cmd('command! Dot lcd $HOME/.dotfiles/ | Dirvish ~/.dotfiles/')
vim.cmd('command! SDot lcd $HOME/.secret_dotfiles/ | Dirvish ~/.secret_dotfiles/')
vim.cmd('command! Secret lcd $HOME/.secret_dotfiles/ | Dirvish ~/.secret_dotfiles/')
vim.cmd('command! S lcd $HOME/.secret_dotfiles/ | Dirvish ~/.secret_dotfiles/')
vim.cmd('command! Alc lcd $HOME/.dotfiles/alacritty/ | edit alacritty.toml')
vim.cmd('command! Sway lcd $HOME/.dotfiles/sway/ | Dirvish ~/.dotfiles/sway')
vim.cmd('command! D lcd $HOME/Downloads | Dirvish ~/Downloads')
vim.cmd('command! Navi lcd $HOME/.dotfiles/navi/ | Dirvish ~/.dotfiles/navi/cheats/my__cheats/')
vim.cmd('command! Config lcd $HOME/.config | Dirvish ~/.config')
vim.cmd('command! C lcd $HOME/.config | Dirvish ~/.config')
vim.cmd('command! Todo lcd $HOME/.secret_dotfiles/nvim/todo/ | edit todo.md')
vim.cmd('command! Tmux lcd /home/wurfkreuz/.dotfiles/tmux | edit .tmux.conf')
vim.cmd('command! Sh lcd /home/wurfkreuz/.dotfiles/scripts/sh | Dirvish ~/.dotfiles/scripts/sh')
vim.cmd('command! Py lcd /home/wurfkreuz/.dotfiles/scripts/python | Dirvish ~/.dotfiles/scripts/python')
vim.cmd('command! Foot lcd /home/wurfkreuz/.dotfiles/foot/ | edit ~/.dotfiles/foot/foot.ini')
vim.cmd('command! Org lcd $HOME/.secret_dotfiles/org/ | Dirvish ~/.secret_dotfiles/org/')
vim.cmd('command! Md lcd $HOME/.secret_dotfiles/markdown | Dirvish ~/.secret_dotfiles/markdown')
vim.cmd('command! Help lcd $HOME/.dotfiles/scripts/sh/help-files | Dirvish ~/.dotfiles/scripts/sh/help-files')
vim.cmd('command! I3 lcd $HOME/.dotfiles/i3 | Dirvish ~/.dotfiles/i3')
vim.cmd('command! STrash lcd $HOME/.secret_dotfiles/trash | Dirvish ~/.secret_dotfiles/trash')
vim.cmd('command! Mc lcd $HOME/.dotfiles/mc/ | Dirvish ~/.dotfiles/mc/')
vim.cmd('command! Source lcd $HOME/.source | Dirvish ~/.source')

vim.cmd([[
  command! StopAllLSP lua for _, client in ipairs(vim.lsp.get_active_clients()) do vim.lsp.stop_client(client) end
]])


-- Current filetype
vim.api.nvim_create_user_command('FT', function()
    print(vim.bo.filetype)
end, {})

