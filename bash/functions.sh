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
}

# The '-x' flag is used in my other bindings to directly execute the function.
# Without it, it just inserts name of the function. But adding '\C-m' simulates
# pressing RET. The reason for such approach, is that with direct execution the
# ls output was removing the first line of the prompt.
bind '"\C-s": "clear-ls-all\C-m"'


# Add this to your ~/.bashrc or ~/.bash_profile
backward_kill_word() {
    local word_end=$READLINE_POINT
    local word_start

    # If we're at the start of the line, nothing to do
    if ((READLINE_POINT == 0)); then
        return
    fi

    # If we're on a space, skip all preceding spaces
    while ((word_end > 0)) && [[ ${READLINE_LINE:word_end-1:1} == " " ]]; do
        ((word_end--))
    done

    # Find the start of the word
    word_start=$word_end
    
    # If we're right after a slash, move back one character
    if ((word_start > 0)) && [[ ${READLINE_LINE:word_start-1:1} == "/" ]]; then
        ((word_start--))
    fi

    # Move backward until we find a slash or space
    while ((word_start > 0)); do
        local prev_char=${READLINE_LINE:word_start-1:1}
        if [[ $prev_char == "/" ]]; then
            break
        fi
        if [[ $prev_char == " " ]] && ((word_start != word_end)); then
            break
        fi
        ((word_start--))
    done

    # Delete the word
    READLINE_LINE=${READLINE_LINE:0:word_start}${READLINE_LINE:word_end}
    READLINE_POINT=$word_start
}

bind -x '"\C-w": backward_kill_word'


paste_from_clipboard() {
    local clipboard_content

    # Try Wayland first
    if command -v wl-paste >/dev/null 2>&1; then
        clipboard_content=$(wl-paste)
    # Fall back to X11
    elif command -v xclip >/dev/null 2>&1; then
        clipboard_content=$(xclip -selection clipboard -o)
    else
        echo "Error: Please install wl-clipboard or xclip" >&2
        return 1
    fi

    # Insert the clipboard content at cursor position
    READLINE_LINE=${READLINE_LINE:0:READLINE_POINT}${clipboard_content}${READLINE_LINE:READLINE_POINT}
    ((READLINE_POINT+=${#clipboard_content}))
}

bind -x '"\C-y": paste_from_clipboard'


# Add this to your ~/.bashrc
print_current_directory_inline() {
    # Get the current directory
    local current_dir=$PWD
    
    # Insert at cursor position
    READLINE_LINE=${READLINE_LINE:0:READLINE_POINT}${current_dir}${READLINE_LINE:READLINE_POINT}
    # Move cursor to end of inserted text
    ((READLINE_POINT+=${#current_dir}))
}

# Add this to your ~/.bashrc
print_current_directory_inline() {
    # Get the current directory
    local current_dir=$PWD
    
    # Insert at cursor position
    READLINE_LINE=${READLINE_LINE:0:READLINE_POINT}${current_dir}${READLINE_LINE:READLINE_POINT}
    # Move cursor to end of inserted text
    ((READLINE_POINT+=${#current_dir}))
}

# First unbind Ctrl+f
bind '"\C-f": nop'

# Then bind our sequence
bind -x '"\C-f\C-p": print_current_directory_inline'
