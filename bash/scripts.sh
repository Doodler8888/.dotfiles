#!/bin/bash


function nvm() {
 cd ~/.dotfiles/nvim/ && nvim .
}

# function t() {
#   if tmux list-sessions &> /dev/null; then
#    if [[ -z "$1" ]]; then
#     tmux attach-session -t 0
#    else 
#     tmux attach-session -t "$1"
#    fi
#   else
#    tmux
#  fi
# }


function take() {
  mkdir -p "$1"
  cd "$1" || return
}


# function zj() {
#   if zellij list-sessions &> /dev/null; then
#    if [[ -z "$1" ]]; then
#     zellij attach
#    else 
#     zellij attach -t "$1"
#    fi
#   else
#    zellij
#  fi
# }
# export -f zj


# function bak() {
#  cp -r "$1" "$1.bak"
# }
#
#
# function unbak() {
#   if [[ "$1" == *.bak ]]; then
#     mv "$1" "${1%.bak}"
#   fi
# }
