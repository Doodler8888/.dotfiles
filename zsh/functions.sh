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

function fzf-recent() {
    local dir
	dir=$(cat ~/.dotfiles/scripts/python/script_files/d_dirs | fzf --height 40% --border) && cd "$dir"
    zle reset-prompt
}
zle -N fzf-recent

function fzf-zoxide() {
    processed_lines=""
    while IFS= read -r line; do
	if [ -d "$line" ]; then
	    processed_lines=$(printf "%s\n%s" "$processed_lines" "$line")
	else
	    continue
	fi
    done < ~/.dirs # if i do 'cat ~/.dirs' instead, then it sets the $processed_lines in a subshell, which mean the code that is out of this scope don't get the variable.
    dir=$(echo "$processed_lines" | fzf --height 40% --border) && cd "$dir"
    zle reset-prompt
}
zle -N fzf-zoxide

# Modified function that waits for 'Ctrl-r' or 'Ctrl-c' after 'Ctrl-f' is pressed
function wait_for_ctrl_r_or_c {
  local key
  # Read a single character
  read -r -sk 1 key
  # The character code for Ctrl-r is ^R or \x12, and for Ctrl-c is ^C or \x03
  # if [[ "$key" == $'\C-r' ]]; then
  #   fd-search # Execute fd-search if Ctrl-r is pressed
  # elif [[ "$key" == $'\C-f' ]]; then
  #   fd-lsearch # Execute fd-lsearch if Ctrl-c is pressed
  # elif [[ "$key" == $'\C-h' ]]; then
  #   fd-lsearchh
  if [[ "$key" == $'\C-z' ]]; then
    fzf-zoxide
  elif [[ "$key" == $'\C-r' ]]; then
    fzf-recent
  # elif [[ "$key" == $'\C-e' ]]; then
  #   fzf-nvim
  # elif [[ "$key" == $'\C-d' ]]; then
  #   systemctl-tui
  # elif [[ "$key" == $'\C-p' ]]; then
  #   print_current_directory_inline
  elif [[ "$key" == $'\p' ]]; then
    print_current_directory_inline
  # elif [[ "$key" == $'C-v' ]]; then
  #   fzf-copy-notify
  # elif [[ "$key" == $'\C-b' ]]; then
  #   switch_branch
  elif [[ "$key" == $'\y' ]]; then
    Cp
  fi
}

# Create a ZLE widget for the modified function
zle -N wait_for_ctrl_r_or_c

# bindkey '^h' wait_for_ctrl_r_or_c
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

# ss() {
#   # set -x - debugging
#   local session
#   # session=$(zellij list-sessions | fzf --height=10 --layout=reverse --border --ansi)
#   session=$(tmux list-sessions | fzf --height=10 --layout=reverse --border --ansi)
#   if [[ -n "$session" ]]; then
#       # zellij attach "$(echo "$session" | awk '{print $1}')"
#       tmux attach -t "$(echo "$session" | awk '{print $1}' | sed 's/:$//')"
#   fi
# }
# zle -N ss


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
# Bind C-v (octal \026) to paste from the system clipboard
bindkey '\026' paste-from-clipboard
# # Bind C-y to the paste widget using the octal code
# bindkey '\031' paste-from-clipboard
bindkey '\031' yank


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
    selected=$(fc -ln 0 | awk '!seen[$0]++' | grep -F "$BUFFER" | tac | fzf \
                                                                      --scheme=history \
        	                                                      --height "40%" \
        	                                                      -n2..,.. \
        	                                                      --tiebreak=index \
            )
    local ret=$?
    if [ -n "$selected" ]; then
        # Convert literal \n to actual newlines
        selected=${selected//\\n/$'\n'}
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

    # If there are no characters before cursor, return
    if [[ $CURSOR -eq 0 ]]; then
        return
    fi

    # Check if we're dealing with a path (contains slash)
    if [[ ! ${BUFFER:0:$CURSOR} =~ / ]]; then
        # Not a path, use regular word deletion
        local WORDCHARS=''
        zle backward-kill-word
        return
    fi

    # Check if we're right after a space
    if [[ ${BUFFER:$((CURSOR-1)):1} == " " ]]; then
        # Delete the space
        BUFFER="${BUFFER:0:$((CURSOR-1))}${BUFFER:$CURSOR}"
        CURSOR=$((CURSOR-1))

        # Then trigger delete again to delete the word before the space
        if [[ $CURSOR -gt 0 ]]; then
            local text_before=${BUFFER:0:$CURSOR}
            local last_slash_pos=${text_before##*/}
            local last_word_len=${#last_slash_pos}

            # If there's a word after the last slash
            if [[ $last_word_len -gt 0 ]]; then
                CURSOR=$((CURSOR - last_word_len))
                BUFFER="${BUFFER:0:$CURSOR}${BUFFER:$CURSOR_BEFORE-1}"
            fi
        fi
        return
    fi

    # If cursor is right after a slash, delete until previous slash
    if [[ ${BUFFER:$((CURSOR-1)):1} == "/" ]]; then
        local slash_pos=${BUFFER:0:$((CURSOR-1))}
        # If there's no previous slash, delete everything up to cursor
        if [[ ! $slash_pos =~ / ]]; then
            BUFFER="${BUFFER:$CURSOR}"
            CURSOR=0
            return
        fi
        slash_pos=${slash_pos%/*}
        local slash_length=${#slash_pos}
        CURSOR=$((slash_length + 1))
        BUFFER="${BUFFER:0:$CURSOR}${BUFFER:$CURSOR_BEFORE}"
        return
    fi

    # Handle words after a space (like "newpath123" in your example)
    if [[ ${BUFFER:0:$CURSOR} =~ " " ]]; then
        local last_space=${BUFFER:0:$CURSOR}
        last_space=${last_space##* }
        # Check if we're in a word after a space
        if [[ ${#last_space} -gt 0 ]]; then
            # Find position of the last space
            local space_pos=${BUFFER:0:$CURSOR}
            space_pos=${space_pos%"$last_space"}
            local space_length=${#space_pos}

            # Delete the word after the space
            CURSOR=$space_length
            BUFFER="${BUFFER:0:$CURSOR}${BUFFER:$CURSOR_BEFORE}"
            return
        fi
    fi

    # Default case: Find the previous slash position and the word after it
    local path_part=${BUFFER:0:$CURSOR}
    local after_last_slash=${path_part##*/}
    local word_len=${#after_last_slash}

    if [[ $word_len -gt 0 ]]; then
        # Delete the word after the last slash
        CURSOR=$((CURSOR - word_len))
        BUFFER="${BUFFER:0:$CURSOR}${BUFFER:$CURSOR_BEFORE}"
    else
        # We're at a path boundary, delete until previous slash
        local prev_path=${path_part%/*}
        local prev_path_length=${#prev_path}

        if [[ $prev_path_length -gt 0 ]]; then
            CURSOR=$((prev_path_length + 1))
            BUFFER="${BUFFER:0:$CURSOR}${BUFFER:$CURSOR_BEFORE}"
        else
            # If we're at the root level, just delete the slash
            CURSOR=$((CURSOR - 1))
            BUFFER="${BUFFER:0:$CURSOR}${BUFFER:$CURSOR_BEFORE}"
        fi
    fi
}

zle -N delete_word_backward
# bindkey '^W' delete_word_backward


fzf-copy-notify() {
notify-send "Copied to clipboard" "$(echo "$current_dir" | fold -w 50)"
}
# autoload fzf-copy-notify
# zle -N fzf-copy-notify
# bindkey '^0' fzf-copy-notify

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

q() {
    xbps-query -Rs "*$1*"
}


gateway() {
	ip route show | grep default | awk '{print $3}'; echo; echo \"To see every existing gateway, use 'ip route show'\";
}


steam-shutdown() {
  kill "$(pgrep -o steam)"
}
