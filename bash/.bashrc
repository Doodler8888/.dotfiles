source /home/wurfkreuz/.dotfiles/bash/scripts.sh
export PATH="$HOME/.nimble/bin:$HOME/.cargo/bin:$HOME/go/bin:$HOME/.local/bin:/usr/bin:/home/wurfkreuz/.ghcup/bin:/home/wurfkreuz/.cabal/bin:/home/wufkreuz/.local/share/racket:$PATH"
export EDITOR=/usr/local/bin/nvim
# export CDPATH=.:~:/usr/local:/etc:~/.dotfiles:~/.config:~/.projects
export STARSHIP_CONFIG="/home/wurfkreuz/.dotfiles/starship/starship.toml"
export PATH="$PATH:/home/wurfkreuz/.ghcup/hls/2.4.0.0/bin"
export PATH="$PATH:/home/wurfkreuz/.cabal/"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git --exclude .snapshots --exclude var --exclude opt --exclude lib --exclude lib64 --exclude mnt --exclude proc --exclude run --exclude sbin --exclude srv --exclude sys --exclude tmp . /'
export BOT_TOKEN="5907946679:AAExBdsBoE_et6XSF_A7DJIrpoNye7iGk8E"

# # If not running interactively, don't do anything
# [[ $- != *i* ]] && return

# shopt -s autocd
shopt -s checkjobs
shopt -s globstar

shopt -s histappend
# HISTCONTROL=ignoredups:erasedups
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
export HISTSIZE=2000

stty -ixon

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='\W > '

# Enable tab completion when starting a command with 'sudo'
[ "$PS1" ] && complete -cf sudo

# shellcheck disable=SC1090
complete -C cli-tree cli-tree
complete -C t t

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
alias s='source $HOME/.dotfiles/bash/.bashrc'
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
alias zsh='cd /home/wurfkreuz/.dotfiles/zsh/ && nvim .zshrc'
alias ls='exa'
alias sl='exa'
alias la='exa -lah'
alias ld='exa -ld'
alias ls.='exa -a | grep -E "^\."'
alias tree='exa -T'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias push='git add . && git commit -m "n" && git push'
alias zd='zellij delete-all-sessions'
alias g='git'
alias notes='nvim "$HOME/notes.txt"'
alias backup='sudo timeshift --create --comments'
alias ff='rg --files | fzf'
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
# alias nvm='cd ~/.dotfiles/nvim/ && nvim .'
alias install='sudo pacman -Syu'
alias orphaned='sudo pacman -Qtdq'
alias hello='echo "Hello"'
alias inpt='cd $HOME/.dotfiles/bash && nvim .inputrc'

eval "$(zoxide init bash)"

if ! pgrep -x "swww-daemon" > /dev/null; then
    swww init 2> /dev/null
    swww img "$HOME/Downloads/pictures/68747470733a2f2f692e696d6775722e636f6d2f4c65756836776d2e676966.gif"
fi

eval "$(starship init bash)"

fzf_history_search() {
    local output=$(history | fzf --tac --tiebreak=index +s --query="$READLINE_LINE")
    READLINE_LINE=$(echo "$output" | sed 's/ *[0-9]* *//')
    READLINE_POINT=${#READLINE_LINE}
}
bind -x '"\C-r": fzf_history_search'

fzf_nvim_with_sudo() {
    local file
    file=$(fzf --height 40% --border)

    if [[ -n "$file" ]]; then
        if [[ ! -w "$file" ]]; then
            SUDO_EDITOR="nvim" sudoedit "$file"
        else
            nvim "$file"
        fi
    fi
}
bind -x '"\C-e": fzf_nvim_with_sudo'

fzf_insert_path() {
    local file
    file=$(fd --type f --hidden . | fzf --height 40% --border)
    if [[ -n "$file" ]]; then
        READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$file${READLINE_LINE:$READLINE_POINT}"
        READLINE_POINT=$(( READLINE_POINT + ${#file} ))
    fi
}
bind -x '"\C-l": fzf_insert_path'

fzf_list_path() {
    local file
    file=$(fd --hidden . / | fzf --height 40% --border)
    if [[ -n "$file" ]]; then
        READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$file${READLINE_LINE:$READLINE_POINT}"
        READLINE_POINT=$(( READLINE_POINT + ${#file} ))
    fi
}
bind -x '"\C-y": fzf_list_path'

# attach_zellij_session() {
#     local session
#     session=$(zellij list-sessions | fzf --height=10 --layout=reverse --border --ansi) && \
#     [ -n "$session" ] && zellij attach "$(echo "$session" | awk '{print $1}')"
# }
# bind -x '"\C-s": attach_zellij_session'

prepend_sudo() {
    READLINE_LINE="sudo $READLINE_LINE"
    READLINE_POINT=$((READLINE_POINT+5))
}
bind -x '"\C-o": prepend_sudo'

[ -f "/home/wurfkreuz/.ghcup/env" ] && source "/home/wurfkreuz/.ghcup/env" # ghcup-env
