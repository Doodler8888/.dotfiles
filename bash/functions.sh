prepend_sudo() {
    READLINE_LINE="sudo $READLINE_LINE"
    READLINE_POINT=$((READLINE_POINT+5))
}
bind -x '"\C-o": prepend_sudo'


function my_fzf_history_widget() {
    local selected
    selected=$(history | 
        awk '!seen[$0]++' | 
        cut -c 8- |
        fzf --height 40% --bind='ctrl-r:toggle-sort,ctrl-z:ignore' \
        --query="$READLINE_LINE")
    
    if [ -n "$selected" ]; then
        READLINE_LINE="$selected"
        READLINE_POINT=${#READLINE_LINE}
    fi
}

bind -x '"\C-r": my_fzf_history_widget'


# More sophisticated version with fuzzy matching
expand_path_fuzzy() {
    local path="$1"
    local parts=(${path//\// })
    local current_path="/"
    local expanded=""

    for part in "${parts[@]}"; do
        if [ -z "$part" ]; then
            continue
        fi
        # Convert part to regex pattern
        local pattern=$(echo "$part" | sed 's/./.*&/g')
        local matches=($(find "$current_path" -maxdepth 1 -type d | grep -i "$pattern" 2>/dev/null))
        
        if [ ${#matches[@]} -eq 1 ]; then
            current_path="${matches[0]}/"
            expanded="${current_path}"
        elif [ ${#matches[@]} -gt 1 ]; then
            echo "Multiple matches:"
            printf '%s\n' "${matches[@]}"
            return 1
        else
            echo "No matches for: $part"
            return 1
        fi
    done
    
    echo "$expanded"
}

bind -x '"\C-a": expand_path_fuzzy'

clear-ls-all() {
  clear
  ls -la --color=auto
  # echo -n "\033[1A"  # Move cursor up one line
  # zle send-break
}

bind -x '"\C-s": clear-ls-all'
