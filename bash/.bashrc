source /home/wurfkreuz/.dotfiles/scripts/sh/bak.sh
source /home/wurfkreuz/.dotfiles/bash/functions.sh

export PATH="$HOME/.nimble/bin:$HOME/.cargo/bin:$HOME/go/bin:$HOME/.local/bin:/usr/bin:/home/wurfkreuz/.ghcup/bin:/home/wurfkreuz/.cabal/bin:/home/wufkreuz/.local/share/racket:$PATH"
export EDITOR=nvim
export CDPATH=.:~:/usr/local:/etc:~/.dotfiles:~/.config:~/.projects:~/.source
export PATH="$PATH:/home/wurfkreuz/.ghcup/hls/2.4.0.0/bin"
export PATH="$PATH:/home/wurfkreuz/.cabal/"

# # If not running interactively, don't do anything
# [[ $- != *i* ]] && return

bind -m vi-command '"ge":edit-and-execute-command'

shopt -s autocd
shopt -s checkjobs
shopt -s globstar

shopt -s histappend
# HISTCONTROL=ignoredups:erasedups
export HISTSIZE=2000

# PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
# PS1='\W > '
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
PS1='\[\033[01;34m\]\w\[\033[38;2;180;142;173m\]$(parse_git_branch)\[\033[00m\]\n\[\033[38;2;208;135;112m\]>\[\033[00m\] '
# This executes BEFORE showing the prompt
PROMPT_COMMAND="history -a; history -c; history -r"

# Colors for gnu ls output
unset LS_COLORS
export LS_COLORS="ln=38;2;76;86;106"

stty -ixon

# Enable tab completion when starting a command with 'sudo'
[ "$PS1" ] && complete -cf sudo

# shellcheck disable=SC1090
# complete -C cli-tree cli-tree
# complete -C t t

alias keys="e /etc/X11/xorg.conf.d/00-keyboard.conf"
alias emacsd="/usr/bin/emacs --daemon &"
alias emacsc="emacsclient -c -a 'emacs'"
alias emc="cd /home/wurfkreuz//.emacs.d/ && nvim config.org"
alias hpr="cd /home/wurfkreuz/.dotfiles/hyprland/ && nvim hyprland.conf"
alias str="cd /home/wurfkreuz/.dotfiles/starship/ && nvim starship.toml"
alias scripts='cd /home/wurfkreuz/.dotfiles/bash/ && nvim scripts.sh'
alias rename='perl-rename'
alias d='cd'
alias key='cd ~/.dotfiles/keyd/ && nvim default.conf'
alias h='history'
alias font='fc-cache -f -v'
alias font-list='fc-list : family'
alias cr='cp -r'
alias alc='cd ~/.dotfiles/alacritty && nvim alacritty.toml'
alias qtl='cd ~/.dotfiles/qtile && nvim config.py'
alias v='nvim'
alias v.='nvim .'
alias zlj='cd ~/.dotfiles/zellij && nvim config.kdl'
alias tmx='cd ~/.dotfiles/tmux && nvim .tmux.conf'
alias back='cd -'
alias di='docker images'
alias bsh='cd ~/.dotfiles/bash/ && nvim .bashrc'
alias ble='cd ~/.dotfiles/bash/ && nvim .blerc'
alias mstart='minikube start'
alias mstatus='minikube status'
alias k='kubectl'
alias kdescribe='kubectl describe'
alias kapply='kubectl apply'
alias rm_untagged='docker rm $(docker ps -a -q -f "status=exited") && docker rmi $(docker images -f "dangling=true" -q)'
alias console='sudo -u postgres psql'
alias compile='nim c -d:release'
alias rf='rm -rf'
alias md='mkdir -p'
alias s='source $HOME/.bashrc'
alias ve='source ./venv/bin/activate && nvim .'
alias st='tmux source-file'
alias menv='python3 -m venv ./venv'
alias senv='source ./venv/bin/activate'
alias denv='deactivate'
alias sstart='sudo systemctl start'
alias sstop='sudo systemctl stop'
alias srestart='sudo systemctl restart'
alias sstatus='sudo systemctl status'
alias senable='sudo systemctl enable'
alias sdisable='sudo systemctl disable'
alias sdi='sudo dnf install'
alias sdrm='sudo dnf remove'
alias sdri='sudo dnf reinstall'
alias sdur='sudo dnf update --refresh'
alias tpla='tmuxp load /home/wurfkreuz/.tmux_layouts/ansible_layout.yml'
alias tplgp='tmuxp load /home/wurfkreuz/.tmux_layouts/go_py_layout.yml'
alias ssh-DO='ssh -i /home/wurfkreuz/.ssh/DOw wurfkreuz@209.38.196.169'
alias ap='ansible-playbook'
alias apK='ansible-playbook -K'
alias channels='nix-channel --update home-manager'
alias search='nix-env -qa'
alias switch='home-manager switch'
alias e='sudo -e'
alias home='nvim /home/wurfkreuz/.dotfiles/home-manager/home.nix'
# alias off="poweroff"
alias off="loginctl poweroff"
alias re="loginctl reboot"
alias ls='ls --color=auto'
alias la='ls -la --color=auto'
alias grep='grep --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias push='git add . && git commit -m "n" && git push'
alias zd='zellij delete-all-sessions'
alias g='git'
alias notes='nvim "$HOME/notes.txt"'
alias backup='sudo timeshift --create --comments'
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
# alias nvm='cd ~/.dotfiles/nvim/ && nvim .'
alias install='doas xbps-install -Sy'
alias remove='doas xbps-remove -R'
alias orphaned='sudo pacman -Qtdq'
alias hello='echo "Hello"'
alias inpt='cd $HOME/.dotfiles/bash && nvim .inputrc'


if ! pgrep -x "swww-daemon" > /dev/null; then
    swww init 2> /dev/null
    swww img "$HOME/Downloads/pictures/68747470733a2f2f692e696d6775722e636f6d2f4c65756836776d2e676966.gif"
fi
