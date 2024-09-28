source /home/wurfkreuz/.dotfiles/bash/scripts.sh
source /usr/local/bin
source ~/.secret_dotfiles/zsh/.zshrc
export GOPATH=$HOME/go
export PATH="$HOME/.nimble/bin:$HOME/.cargo/bin:$HOME/go/bin:$HOME/.dotfiles:$HOME/.cabal/bin:$HOME/.ghcup/bin:$HOME/.local/bin:/usr/lib:$HOME/perl5/bin:$HOME/.qlot/bin/:$HOME/common-lisp/lem:$HOME/.config/emacs/bin:/var/lib/snapd/snap/bin:$PATH"
export EDITOR='/usr/bin/nvim'
export HISTFILE="$HOME/.zsh_history"
export ZDOTDIR="/home/wurfkreuz/.dotfiles/zsh/"
export STARSHIP_CONFIG="/home/wurfkreuz/.dotfiles/starship/starship.toml"
# export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git --exclude .snapshots --exclude opt --exclude lib --exclude lib64 --exclude mnt --exclude proc --exclude run --exclude sbin --exclude srv --exclude sys --exclude tmp . /'
export FZF_DEFAULT_COMMAND='fd --hidden --exclude .git --exclude .snapshots --exclude opt --exclude lib --exclude lib64 --exclude mnt --exclude proc --exclude run --exclude sbin --exclude srv --exclude sys --exclude tmp --exclude /home/wurfkreuz/.config/vivaldi --exclude /home/wurfkreuz/snap'
# export FZF_DEFAULT_COMMAND='fd --hidden --exclude .git --exclude .snapshots --exclude opt --exclude lib --exclude lib64 --exclude mnt --exclude proc --exclude run --exclude sbin --exclude srv --exclude sys --exclude tmp --exclude ".config/vivaldi" --exclude snap'
export PATH="$PATH:/home/wurfkreuz/.ghcup/hls/2.4.0.0/bin"
export ANSIBLE_CONFIG="~/.dotfiles/ansible/ansible.cfg"
export ANSIBLE_COLLECTIONS_PATH="~/.dotfiles/ansible/ansible_collections"
export RAKU_MODULE_DEBUG="~/.raku/sources"
export PERL5LIB="$HOME/perl5/lib/perl5:$PERL5LIB"
export LSP_USE_PLISTS=true
export LC_ALL=C.UTF-8
export KITTY_CONFIG_DIRECTORY="~/.dotfiles/kitty"
export XDG_CURRENT_DESKTOP="Sway"
export LUA_BINDIR="/usr/local/bin/"
export LUA_BINDIR_SET=yes
export VISUDO_EDITOR=/usr/bin/nvim
export CC=/usr/bin/gcc && export CXX=/usr/bin/gcc

# zstyle ':completion:*' menu select
# zstyle ':completion:*' special-dirs true
# setopt EXTENDED_GLOB
setopt AUTO_CD
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
HISTSIZE=16000
SAVEHIST=16000
# precmd() {}

autoload edit-command-line; zle -N edit-command-line
bindkey -v
bindkey -M viins '\e.' insert-last-word
bindkey -M vicmd ge edit-command-line # edit line using EDITOR
bindkey "^?" backward-delete-char

alias D="cd ~/Downloads"
alias S="cd ~/.source"
alias fnc="cd ~/.dotfiles/zsh/ && nvim functions.sh"
alias j="zellij"
alias hpr="cd /home/wurfkreuz/.dotfiles/hyprland/ && nvim hyprland.conf"
alias str="cd /home/wurfkreuz/.dotfiles/starship/ && nvim starship.toml"
alias scripts='cd /home/wurfkreuz/.dotfiles/bash/ && nvim scripts.sh'
alias rename='perl-rename'
alias u='sudo'
alias key='cd ~/.dotfiles/keyd/ && nvim default.conf'
alias h='history'
alias set_minikube='eval $(minikube docker-env)'
alias update_fonts='fc-cache -f -v'
alias cr='cp -r'
alias alc='cd ~/.dotfiles/alacritty && nvim ~/.dotfiles/alacritty/alacritty.toml'
alias qtl='cd ~/.dotfiles/qtile && nvim ~/.dotfiles/qtile/config.py'
alias v='nvim'
# alias v.='nvim .'
alias zlj='cd ~/.dotfiles/zellij && nvim ~/.dotfiles/zellij/config.kdl'
alias tmx='cd ~/.dotfiles/tmux && nvim ~/.dotfiles/tmux/.tmux.conf'
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
alias run='nim c -r'
alias compile='nim c -d:release'
alias ld='sudo lazydocker'
# alias rm=''
alias rf='rm -rf'
alias md='mkdir -p'
alias s='source ~/.zshrc'
alias ve='source ./venv/bin/activate && nvim .'
alias st='tmux source-file'
alias menv='python3 -m venv ./.venv'
alias senv='source .venv/bin/activate'
alias denv='deactivate'
alias sst='sudo systemctl start'
alias ssp='sudo systemctl stop'
alias srt='sudo systemctl restart'
alias sss='sudo systemctl status'
alias see='sudo systemctl enable'
alias seen='sudo systemctl enable --now'
alias sde='sudo systemctl disable'
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
alias zsh='cd ~/.dotfiles/zsh/ && nvim .zshrc'
alias ls='exa'
alias sl='exa'
alias la='exa -lah'
# alias ld='exa -ld'
alias ls.='exa -a | grep -E "^\."'
alias tree='exa -Ta --ignore-glob='.git''
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
# alias push='git add . && git commit -m "n" && git push'
alias g='git'
alias notes='nvim "$HOME/notes.txt"'
alias backup='sudo timeshift --create --comments'
alias ff='rg --files | fzf'
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias nvm='cd ~/.dotfiles/nvim/ && nvim .'
alias install='sudo pacman -Syu'
alias remove='sudo pacman -R'
alias orphaned='sudo pacman -Qtdq'
alias inpt='cd $HOME/.dotfiles/bash && nvim .inputrc'
alias users="awk -F: '\$3>=1000 && \$1!=\"nobody\" && \$1!~/nixbld/ {print \$1}' /etc/passwd"  # Original: awk: cmd. line:1: >=1000 && !=nobody && !~/nixbld/ {print }
alias books="cd ~/.secret_dotfiles/ansible/playbooks/"
alias hosts="sudo -e /etc/ansible/hosts"
alias scr="cd ~/.dotfiles/scripts/"
alias off="poweroff"
alias run="cargo run"
alias build="cargo build"
alias scr="cd ~/.dotfiles/scripts"
alias nsh="cd ~/.dotfiles/nu && nvim config.nu"
alias ans="cd ~/.dotfiles/ansible"
alias dot="cd ~/.dotfiles"
alias dimages="docker images"
alias dtag="docker tag"
alias dpsa="docker ps -a | head -n 5"
alias cfg="cd ~/.dotfiles/ansible/ && nvim ansible.cfg"
alias comma="bash ~/Downloads/comma/comma-complete-2023.08.0/bin/comma.sh"
alias pg_hba="/var/lib/postgres/data/pg_hba.conf"
alias i3c="nvim ~/.config/i3/config"
bindkey '^R' fzf_history_search

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# # Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

zle_highlight=(region:bg=#524f67)

eval "$(zoxide init zsh)"

source ~/.dotfiles/zsh/functions.sh

# source $HOME/.dotfiles/zsh/config_variables/flashcards_bot

# This block enables vim mode
KEYTIMEOUT=1
function zle-line-init zle-keymap-select {
    if [[ ${KEYMAP} == vicmd ]] ;
    then echo -ne '\e[2 q'
    else echo -ne '\e[6 q'
    fi
}
zle -N zle-line-init
zle -N zle-keymap-select

stty -ixon

bindkey -M viins '^P' up-line-or-history
bindkey -M viins '^N' down-line-or-history
bindkey -M viins '^L' clear-screen

# If i write "source '~/antigen.zsh'", i'll get an error.
source "$HOME/antigen.zsh"

export ZSH_AUTOSUGGEST_STRATEGY=(completion history)
bindkey '^[w' forward-word
bindkey '^a' autosuggest-accept
antigen bundle zsh-users/zsh-autosuggestions &> /dev/null

antigen bundle kutsan/zsh-system-clipboard &> /dev/null
antigen bundle marlonrichert/zsh-autocomplete &> /dev/null
antigen bundle zsh-users/zsh-syntax-highlighting &> /dev/null
antigen apply &> /dev/null

# for the autocomplete plugin
zstyle ':autocomplete:*' ignored-input '##'
# bindkey -r "^R"
# bindkey "^R" history-incremental-pattern-search-backward
# bindkey '^R' history-incremental-search-backward

# if ! pgrep -x "swww-daemon" > /dev/null; then
#     swww init 2> /dev/null
#     swww img "$HOME/Downloads/pictures/68747470733a2f2f692e696d6775722e636f6d2f4c65756836776d2e676966.gif"
# fi

# eval "$(starship init zsh)"

if [[ -o interactive ]] && [[ "$TERM" != "dumb" ]]; then
    eval "$(starship init zsh)"
else
    # Set a simple prompt for non-interactive or dumb terminals
    PS1='%1~ > '
fi

[ -n "$EAT_SHELL_INTEGRATION_DIR" ] && \
    source "$EAT_SHELL_INTEGRATION_DIR/zsh"

# if [ -z "$SSH_AUTH_SOCK" ] ; then
#     eval "$(ssh-agent -s)" 1> /dev/null # 'ssh-agent -s' start a new ssh agent and print out env variables for it. But because it only prints them out, they have to be evaluated.
# fi
# SSH_KEY_DIR="$HOME/.ssh/keys"
# for key in "$SSH_KEY_DIR"/*; do
#     if [[ -f $key && ! $key =~ \.pub$ ]]; then # The '=~' part is for making a regular expression check. The slash is an escape sequence because a dot has its own meaning for regular expressions.
#         ssh-add "$key" > /dev/null 2>&1
#     fi
# done

PATH="/home/wurfkreuz/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/wurfkreuz/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/wurfkreuz/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/wurfkreuz/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/wurfkreuz/perl5"; export PERL_MM_OPT;
