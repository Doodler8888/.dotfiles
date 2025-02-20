#!/etc/bash

take() {
  mkdir -p "$1"
  cd "$1" || return
}


note() {
  {
    echo "date: $(date)" 
    echo "$@" 
    echo "" 
  } >> "$HOME/notes.txt"
}


all() {
  exa -ld "$1" && exa -lh "$1"
}


f() {
    local item
    item=$(fd -H . | fzf)
    if [[ -d $item ]]; then
        cd "$item" || return
    elif [[ -f $item ]]; then
	if [[ $(stat -c "%U" "$item") == "root" ]]; then
	    sudo -e "$item"
	else
	    nvim "$item"
	fi
    fi
}


c() {
  if [[ -f $1 ]]; then
    xclip -sel clip < "$1"
  else echo "File '$1' does not exist or is a directory"
  fi
}


move() {
    target=$1
    shift
    mkdir -p "$target" && mv -t "$target" "$@"
}


unseal() {
    echo "---Starting decryption..."
    key1=$(gpg -d secrets.txt.gpg 2>/dev/null | awk '/Key 1/ {if ($4 != "") print $4}')
    key2=$(gpg -d secrets.txt.gpg 2>/dev/null | awk '/Key 2/ {if ($4 != "") print $4}')
    key3=$(gpg -d secrets.txt.gpg 2>/dev/null | awk '/Key 3/ {if ($4 != "") print $4}')

    token=$(gpg -d secrets.txt.gpg 2>/dev/null | awk '/Initial/ {if ($4 != "") print $4}')

    echo "---Unsealing Vault..."
    vault operator unseal "$key1"
    vault operator unseal "$key2"
    vault operator unseal "$key3"

    echo "---Logging in to Vault..."
    vault login "$token"
}

# push() {
#         git add . && git commit -m "n" && git push
#     }

# fzf-history-widget() {
# 	local selected num
# 	setopt localoptions noglobsubst noposixbuiltins pipefail 2> /dev/null
# 	selected=($(fc -rl 1 | fzf +m \
# 		--height "40%" \
# 		-n2..,.. \
# 		--tiebreak=index \
# 		--bind=ctrl-r:toggle-sort \
# 		--query="${LBUFFER}" \
# 	))
# 	local ret=$?
# 	if [ -n "$selected" ]; then
# 		num=$selected[1]
# 		if [ -n "$num" ]; then
# 			zle vi-fetch-history -n $num
# 		fi
# 	fi
# 	zle reset-prompt
# 	return $ret
# }
# zle -N fzf-history-widget
# bindkey '^R' fzf-history-widget


fd-search() {
 local file
 file=$(fd --hidden . / | fzf --height 40% --border)

 if [[ -n $file ]]; then
   BUFFER="${BUFFER}${file}"
   zle redisplay
   zle end-of-line
 fi
 zle reset-prompt
}
zle -N fd-search
# bindkey '^Y' fd-search


zd-lsearchh() {
 local file
 # Use the $HOME environment variable to specify the home directory
 file=$(fd --hidden . "$HOME" | fzf --height 40% --border)

 if [[ -n $file ]]; then
   BUFFER="${BUFFER}${file}"
   zle redisplay
   zle end-of-line
 fi
 zle reset-prompt
}
zle -N fd-lsearch

fd-lsearch() {
 local file
 # file=$(fd --type f --hidden . | fzf --height 40% --border)
 file=$(fd --hidden . | fzf --height 40% --border)

 if [[ -n $file ]]; then
   BUFFER="${BUFFER}${file}"
   zle redisplay
   zle end-of-line
 fi
 zle reset-prompt
}
zle -N fd-lsearch
# bindkey '^O' fd-lsearch


function fzf-zoxide() {
    local dir
    # dir=$(zoxide query --list | fzf --height 40% --border) && cd "$dir"
    # dir=$(zoxide query --list | pick) && cd "$dir"
    # dir=$(cat ~/.dirs | pick) && cd "$dir"
	dir=$(cat ~/.dirs | fzf --height 40% --border) && cd "$dir"
    zle reset-prompt
}
zle -N fzf-zoxide

# Modified function that waits for 'Ctrl-r' or 'Ctrl-c' after 'Ctrl-f' is pressed
function wait_for_ctrl_r_or_c {
  local key
  # Read a single character
  read -r -sk 1 key
  # The character code for Ctrl-r is ^R or \x12, and for Ctrl-c is ^C or \x03
  if [[ "$key" == $'\C-r' ]]; then
    fd-search # Execute fd-search if Ctrl-r is pressed
  elif [[ "$key" == $'\C-f' ]]; then
    fd-lsearch # Execute fd-lsearch if Ctrl-c is pressed
  elif [[ "$key" == $'\C-h' ]]; then
    fd-lsearchh
  elif [[ "$key" == $'\C-z' ]]; then
    fzf-zoxide
  elif [[ "$key" == $'\C-e' ]]; then
    fzf-nvim
  elif [[ "$key" == $'\C-d' ]]; then
    systemctl-tui
  elif [[ "$key" == $'\C-p' ]]; then
    print_current_directory_inline
  elif [[ "$key" == $'\C-b' ]]; then
    switch_branch
  elif [[ "$key" == $'\C-y' ]]; then
    Cp
  fi
}

# Create a ZLE widget for the modified function
zle -N wait_for_ctrl_r_or_c

# Bind 'Ctrl-f' to the new widget
bindkey '^h' wait_for_ctrl_r_or_c

fzf-nvim() {
    local file
    file=$(fd --type f --hidden . / | fzf --height 40% --border)

    if [[ -n $file ]]; then
        # Check if the file is owned by root
        if [[ $(stat -c "%U" "$file") == "root" ]]; then
            # If root-owned, use sudoedit
            BUFFER="sudoedit $file"
        else
            # Otherwise, use nvim
            BUFFER="nvim $file"
        fi
        zle accept-line  # Execute the command
    fi
    zle reset-prompt
}
zle -N fzf-nvim
# bindkey '^E' fzf-nvim

ss() {
  # set -x - debugging
  local session
  session=$(zellij list-sessions | fzf --height=10 --layout=reverse --border --ansi)
  if [[ -n "$session" ]]; then
    zellij attach "$(echo "$session" | awk '{print $1}')"
  fi
}
zle -N ss


d() {
    cd "$1" || return
    exa -la
}


clear-ls-all() {
    clear
    ls -la --color=auto
}
# I try to simulate the same solution for this function as i did it for bash.
bindkey -s '^S' 'clear-ls-all\n'


# clear-ls-all() {
#   clear
#   eza -al
#   echo -n "\033[1A"  # Move cursor up one line
#   zle send-break
# }
# zle -N clear-ls-all
# bindkey '^S' clear-ls-all


freeze() {
  # Check if VIRTUAL_ENV is set, indicating a virtual environment is active
  if [ -n "$VIRTUAL_ENV" ]; then
    # Run pip freeze and save the output to requirements.txt within the virtual environment
    pip freeze > requirements.txt
    echo "Updated"
  else
    echo "No virtual environment detected. Trying to activate it..."
    source .venv/bin/activate
    pip freeze > requirements.txt
  fi
}


print_current_directory_inline() {
    LBUFFER+=$PWD
    zle redisplay
}
zle -N print_current_directory_inline
# bindkey '^F^P' print_current_directory_inline


switch_branch() {
  local branch=$(git branch | fzf --height 40% --reverse --prompt="Switch to branch: " | sed 's/^[* ] //')
  if [ -n "$branch" ]; then
    git switch "$branch"
  else
    echo "No branch selected"
  fi
  zle reset-prompt
}
zle -N switch_branch


# Define the Cp function to copy the current directory path to the clipboard
Cp() {
  # Store the current directory path in a variable
  local current_dir="$(pwd)"
  if command -v wl-copy &> /dev/null; then
    echo -n "$current_dir" | wl-copy
  else
    echo "Error: No clipboard utility found. Install xclip, wl-copy, or pbcopy."
    return 1
  fi

  # Notify the user that the path has been copied
  # echo "Copied current directory path to clipboard: $current_dir"
  notify-send "Copied to clipboard" "$(echo "$current_dir" | fold -w 50)"
    # zle reset-prompt
}
zle -N Cp

# Create a widget for pasting
paste-from-clipboard() {
    if [ -n "$WAYLAND_DISPLAY" ]; then
        LBUFFER+="$(wl-paste)"
    else
        LBUFFER+="$(xclip -selection clipboard -o)"
    fi
}
zle -N paste-from-clipboard
# Bind C-y to the paste widget using the octal code
bindkey '\031' paste-from-clipboard


switch() {
  sudo nixos-rebuild switch
  sudo cp /etc/nixos/configuration.nix ~/.dotfiles/nix
  sudo cp /etc/nixos/home.nix ~/.dotfiles/nix
  sudo cp /etc/nixos/flake.nix ~/.dotfiles/nix
}


sv-down() {
    if [ -z "$1" ]; then
        echo "Usage: sv-down service_name"
        echo "Example: sv-down lightdm"
        return 1
    fi

    local SERVICE="$1"
    echo "Stopping $SERVICE..."
    sudo sv down "$SERVICE"
    
    echo "Removing service link..."
    sudo rm "/var/service/$SERVICE"
    
    echo "Service $SERVICE has been stopped and removed."
}

# Function to enable a service
sv-up() {
    if [ -z "$1" ]; then
        echo "Usage: sv-up service_name"
        echo "Example: sv-up sddm"
        return 1
    fi

    local SERVICE="$1"
    
    if [ ! -d "/etc/sv/$SERVICE" ]; then
        echo "Error: Service '$SERVICE' not found in /etc/sv/"
        return 1
    fi

    echo "Enabling $SERVICE..."
    sudo ln -s "/etc/sv/$SERVICE" "/var/service/"
    
    echo "Service $SERVICE has been enabled."
}


# bak() {
#     local do_copy=false
    
#     # Parse options
#     while getopts "c" opt; do
#         case $opt in
#             c) do_copy=true ;;
#             *) echo "Usage: bak [-c] filename|directory"; return 1 ;;
#         esac
#     done
#     shift $((OPTIND-1))

#     [ $# -eq 0 ] && { echo "Usage: bak [-c] filename|directory"; return 1; }
#     [ ! -e "$1" ] && [ ! -e "${1%.bak}" ] && { echo "Error: File/directory does not exist"; return 1; }
    
#     # Remove trailing slash if present
#     local target="${1%/}"
    
#     if [[ "$target" == *.bak ]]; then
#         if $do_copy; then
#             cp -r "$target" "${target%.bak}"
#         else
#             mv "$target" "${target%.bak}"
#         fi
#     else
#         if $do_copy; then
#             cp -r "$target" "$target.bak"
#         else
#             mv "$target" "$target.bak"
#         fi
#     fi
# }


autoload -U my_fzf_history_widget
function my_fzf_history_widget() {
    local selected
    # selected=$(fc -ln 0 | awk '!seen[$0]++' | pick)
    # tac is used to reverse the order in which fzf shors items in its window initially
    selected=$(fc -ln 0 | awk '!seen[$0]++' | grep -F "$BUFFER" | tac | fzf \
                                                                      --scheme=history \
        	                                                      --height "40%" \
        	                                                      -n2..,.. \
        	                                                      --tiebreak=index \
            )
# 	selected=($(fc -rl 1 | fzf +m \
# 		--height "40%" \
# 		-n2..,.. \
# 		--tiebreak=index \
# 		--bind=ctrl-r:toggle-sort \
# 		--query="${LBUFFER}" \
# 	))
    local ret=$?
    if [ -n "$selected" ]; then
        BUFFER="${selected}"
        CURSOR=$#BUFFER
        zle vi-fetch-history -n $BUFFER
    fi
    zle reset-prompt
    return $ret
}
autoload my_fzf_history_widget
zle -N my_fzf_history_widget
bindkey '^R' my_fzf_history_widget


delete_word_backward() {
    local CURSOR_BEFORE=$CURSOR
    
    # If there's no slash in the text before cursor, use regular word deletion
    if [[ ! ${BUFFER:0:$CURSOR} =~ / ]]; then
        local WORDCHARS=''
        zle backward-kill-word
        return
    fi
    
    # If cursor is right after a slash, delete until previous slash
    if [[ ${BUFFER:$((CURSOR-1)):1} == "/" ]]; then
        local slash_pos=${BUFFER:0:$((CURSOR-1))}
        
        # If there's no previous slash, delete everything up to cursor
        if [[ ! $slash_pos =~ / ]]; then
            BUFFER="${BUFFER:$CURSOR_BEFORE}"
            CURSOR=0
            return
        fi
        
        slash_pos=${slash_pos%/*}
        local slash_length=${#slash_pos}
        CURSOR=$((slash_length + 1))
        BUFFER="${BUFFER:0:$CURSOR}${BUFFER:$CURSOR_BEFORE}"
    else
        # Find the previous slash position
        local slash_pos=${BUFFER:0:$CURSOR}
        slash_pos=${slash_pos%/*}
        local slash_length=${#slash_pos}
        
        # Delete until but not including the slash
        if [[ $slash_length -lt $CURSOR_BEFORE ]]; then
            CURSOR=$((slash_length + 1))
            BUFFER="${BUFFER:0:$CURSOR}${BUFFER:$CURSOR_BEFORE}"
        fi
    fi
}
 
zle -N delete_word_backward
bindkey '^W' delete_word_backward


fzf-copy-notify() {
notify-send "Copied to clipboard" "$(echo "$current_dir" | fold -w 50)"
} 


# incremental_fzf() {
#   local curr_dir="."
#   local selection
#
#   while true; do
#     selection=$(ls -la "$curr_dir" | fzf --header="$curr_dir")
#     if [[ -z "$selection" ]]; then
#       break
#     fi
#
#     # Extract the filename from the ls output
#     filename=$(echo "$selection" | awk '{print $NF}')
#
#     if [[ -d "$curr_dir/$filename" && "$filename" != "." && "$filename" != ".." ]]; then
#       curr_dir="$curr_dir/$filename"
#     else
#       echo "Selected: $curr_dir/$filename"
#       break
#     fi
#   done
# }


vertico_nav_fzf() {
  local depth=1
  local query=""
  
  while true; do
    local selection=$(find . -mindepth 1 -maxdepth $depth -type d | sed 's|^\./||' | fzf \
      --query "$query" \
      --header="Navigate (type a path with / to go deeper)" \
      --bind "change:reload(echo {q} | grep -q '/' && \
              path=\$(echo {q} | sed 's|/[^/]*$||'); \
              find . -mindepth 1 -maxdepth 1 -type d -path \"./\${path:-}*\" | sed 's|^./||' || \
              find . -mindepth 1 -maxdepth 1 -type d | sed 's|^./||')" \
      --preview "ls -la ./{}" \
      --print-query)
    
    query=$(echo "$selection" | head -1)
    selection=$(echo "$selection" | tail -1)
    
    if [ -z "$selection" ]; then
      echo "No selection made"
      return
    fi
    
    if [ -d "./$selection" ]; then
      echo "Selected: $selection"
      return
    fi
  done
}
