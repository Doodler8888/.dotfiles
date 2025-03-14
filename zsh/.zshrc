export DOCKER_CONTENT_TRUST=1
source /usr/local/bin
source $HOME/.dotfiles/zsh/bindings.sh
source ~/.secret_dotfiles/zsh/.zshrc
export GOPATH=$HOME/go
export XDG_HELP_DIR=$HOME/.dotfiles/scripts/sh/help-files
export PATH="/var/lib/flatpak/exports/bin:$HOME/.local/share/flatpak/exports/bin:/usr/local/bin/go/bin:$HOME/.nimble/bin:$HOME/.cargo/bin:$HOME/go/bin:$HOME/.dotfiles:$HOME/.cabal/bin:$HOME/.ghcup/bin:$HOME/.local/bin:/usr/lib:$HOME/perl5/bin:$HOME/.qlot/bin/:$HOME/common-lisp/lem:$HOME/.config/emacs/bin:/var/lib/snapd/snap/bin:$HOME/common-lisp/lem:$HOME/.source/zig/build/stage3/bin:$HOME/.dotfiles/scripts/sh/:$HOME/.dotfiles/scripts/sh/add-cd/:$HOME/.dotfiles/scripts/sh/nvim:$HOME/.dotfiles/scripts/perl/:$HOME/.dotfiles/scripts/python/:$PATH"
GTAGSOBJDIRPREFIX=~/.cache/gtags/
export EDITOR=nvim
export HISTFILE="$HOME/.zsh_history"
export STARSHIP_CONFIG="/home/wurfkreuz/.dotfiles/starship/starship.toml"
export FZF_DEFAULT_COMMAND='fd --hidden --exclude .git --exclude .snapshots --exclude opt --exclude lib --exclude lib64 --exclude mnt --exclude proc --exclude run --exclude sbin --exclude srv --exclude sys --exclude tmp --exclude /home/wurfkreuz/.config/vivaldi --exclude /home/wurfkreuz/snap'
export PATH="$PATH:/home/wurfkreuz/.ghcup/hls/2.9.0.1/bin"
# export ANSIBLE_CONFIG="~/.dotfiles/ansible/ansible.cfg"
# export ANSIBLE_COLLECTIONS_PATH="~/.dotfiles/ansible/ansible_collections"
export PERL5LIB="$HOME/perl5/lib/perl5:$PERL5LIB"
# export LUA_BINDIR="/usr/local/bin/"
# export LUA_BINDIR_SET=yes
export VISUDO_EDITOR=/usr/local/bin/nvim
export CC=/usr/bin/gcc && export CXX=/usr/bin/gcc
# export XAUTHORITY=$HOME/.Xauthority
# export K9S_CONFIG_DIR="~/.config/k9s/"
# export K9S_SKIN="$HOME/.config/k9s/skins/nord_aurora.yaml"

# zstyle ':completion:*' menu select
# zstyle ':completion:*' special-dirs true
# setopt EXTENDED_GLOB
setopt AUTO_CD
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
HISTSIZE=16000
SAVEHIST=16000
# precmd() {}

# Colors for gnu ls output
unset LS_COLORS
export LS_COLORS="ln=38;2;76;86;106"
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
alias set_minikube='eval $(minikube docker-env)'
alias update_fonts='fc-cache -f -v'
alias cr='cp -r'
alias alc='cd ~/.dotfiles/alacritty && nvim ~/.dotfiles/alacritty/alacritty.toml'
alias qtl='cd ~/.dotfiles/qtile && nvim ~/.dotfiles/qtile/config.py'
alias v='nvim'
alias v.='nvim .'
alias zlj='cd ~/.dotfiles/zellij && nvim ~/.dotfiles/zellij/config.kdl'
alias tmx='cd ~/.dotfiles/tmux && nvim ~/.dotfiles/tmux/.tmux.conf'
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
# alias rm=''
alias rf='rm -rf'
alias md='mkdir -p'
alias s='source ~/.zshrc'
alias ve='source ./venv/bin/activate && nvim .'
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
# alias switch='home-manager switch' # i use switch as a function
alias e='sudo -e'
alias home='nvim /home/wurfkreuz/.dotfiles/home-manager/home.nix'
# alias tree='eza -Ta --ignore-glob='.git''
alias ls='ls --color=auto'
alias la='ls -la --color=auto'
alias ld='ls -ld --color=auto'
alias grep='grep --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'# alias push='git add . && git commit -m "n" && git push'
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
# alias install='sudo apt install'
alias remove='sudo apt remove'
alias install='sudo xbps-install -Sy'
alias remove='sudo xbps-remove -R' # '-R' for recursive removal of dependencies
alias query='xbps-query -Rs' # '-R' for recursive removal of dependencies
alias q='xbps-query -Rs' # '-R' for recursive removal of dependencies
alias orphaned='sudo pacman -Qtdq'
alias inpt='cd $HOME/.dotfiles/bash && nvim .inputrc'
alias users="awk -F: '\$3>=1000 && \$1!=\"nobody\" && \$1!~/nixbld/ {print \$1}' /etc/passwd"  # Original: awk: cmd. line:1: >=1000 && !=nobody && !~/nixbld/ {print }
alias playbooks="cd ~/.secret_dotfiles/ansible/playbooks/"
alias books="cd ~/Downloads/books/"
alias hosts="sudo -e /etc/ansible/hosts"
alias scr="cd ~/.dotfiles/scripts/"
# alias off="poweroff"
alias off="loginctl poweroff"
alias off="loginctl poweroff"
alias re="loginctl reboot"
alias run="cargo run"
alias build="cargo build"
alias l="ln -s"
alias -g scr="~/.dotfiles/scripts"
alias -g src="~/.source"
alias -g dot="~/.dotfiles"
alias -g sdot="~/.secret_dotfiles"
alias -g bin="/usr/local/bin"
alias -g cfg="~/.config"
alias -g home="~/"
alias dimages="docker images"
alias dtag="docker tag"
alias dpsa="docker ps -a | head -n 5"
alias comma="bash ~/Downloads/comma/comma-complete-2023.08.0/bin/comma.sh"
alias pg_hba="/var/lib/postgres/data/pg_hba.conf"
alias i3c="nvim ~/.config/i3/config"
alias mk="minikube"
alias lzd="lazydocker"
alias lzg="lazygit"
alias dit="docker inspect"
alias dis='docker images'
alias os="cat /etc/os-release"
# alias os="cat /etc/lsb-release"
alias clone="git clone"
alias lg="lazygit"
alias trash="cd /home/wurfkreuz/.local/share/trash"
alias update="sudo apt update && sudo apt upgrade"
alias tmux-source="tmux source-file ~/.tmux.conf"
alias t-s="tmux source-file ~/.tmux.conf"
alias cm="chmod"
alias sv-list="ls /var/service/"
alias ulb="/usr/local/bin"
alias hso="/home/wurfkreuz/.secret_dotfiles/org/"
alias grv="git remote -v"
alias grr="git remote rm"
alias cd-add="add-cd"
alias a-c="add-cd"
alias c-a="add-cd"

autoload -Uz compinit; compinit;
bindkey "^Xa" _expand_alias
zstyle ':completion:*' completer _expand_alias _complete _ignored
zstyle ':completion:*' regular true

# Command auto-correction.
ENABLE_CORRECTION="true"

zle_highlight=(region:bg=#524f67)

source ~/.dotfiles/zsh/functions.sh

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

# I manually use the plugin instead of dealing with any pluging managers
# git clone https://github.com/kutsan/zsh-system-clipboard
source "$HOME/.source/zsh-system-clipboard/zsh-system-clipboard.zsh"
if [ "$XDG_SESSION_TYPE" != "wayland" ]; then
    ZSH_SYSTEM_CLIPBOARD_METHOD=xcc
    typeset -g ZSH_SYSTEM_CLIPBOARD_METHOD
fi


parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

venv_prompt() {
  [[ -n $VIRTUAL_ENV ]] && echo " ($(basename $VIRTUAL_ENV))"
}

setopt PROMPT_SUBST
PROMPT=$'%{\e[1;34m%}%~%{\e[1;38;2;180;142;173m%}$(venv_prompt)$(parse_git_branch)%{\e[0m%}\n%{\e[38;2;208;135;112m%}>%{\e[0m%} '

# if [ -z "$SSH_AUTH_SOCK" ]; then
# 	if [ -z "$(pgrep ssh-agent)" ]; then
# 		eval "$(ssh-agent)" > /dev/null
# 	else
# 		export SSH_AUTH_SOCK="$(find /tmp/ssh-*/agent.* | head -n 1)"
# 	fi
# 	if [ -d ~/.ssh ] || [ -h ~/.ssh ]; then
# 		find -L "$HOME"/.ssh -type f \
# 			 ! -name '*.pub' \
# 			 ! -name "config" \
# 			 ! -name 'known_hosts*' \
# 			 ! -name 'authorized_key*' |
# 			while IFS= read -r input; do
# 				chmod 600 "$input"
# 				ssh-add "$input" > /dev/null 2>&1 # for some reason it prints output through stderr
# 			done
# 	fi
# fi


PATH="/home/wurfkreuz/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/wurfkreuz/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/wurfkreuz/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/wurfkreuz/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/wurfkreuz/perl5"; export PERL_MM_OPT;

[[ "$PATH" == *"$HOME/bin:"* ]] || export PATH="$HOME/bin:$PATH"
! { which werf | grep -qsE "^/home/wurfkreuz/.trdl/"; } && [[ -x "$HOME/bin/trdl" ]] && source $("$HOME/bin/trdl" use werf "2" "stable")

# if [ -e /home/wurfkreuz/.nix-profile/etc/profile.d/nix.sh ]; then . /home/wurfkreuz/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(direnv hook zsh)"
# eval "$(starship init zsh)"
