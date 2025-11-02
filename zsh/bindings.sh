autoload edit-command-line; zle -N edit-command-line
bindkey -v
bindkey -M viins '\e.' insert-last-word
bindkey -M vicmd ge edit-command-line # edit line using EDITOR
bindkey "^?" backward-delete-char
bindkey -M vicmd 'Y' vi-yank-eol
bindkey '^R' fzf_history_search

# Insert Mode (viins)
bindkey -M viins '^A' beginning-of-line    # C-a: Move to start of line
bindkey -M viins '^E' end-of-line          # C-e: Move to end of line
bindkey -M viins '^K' kill-line            # C-k: Kill to end of line
bindkey -M viins '^U' backward-kill-line   # C-u: Delete entire line
bindkey -M viins '^W' backward-kill-word   # C-w: Delete previous word
bindkey -M viins '^[d' kill-word   # M-d: delete forward word
bindkey -M viins '^[f' forward-word        # M-f: Move forward one word
bindkey -M viins '^[b' backward-word       # M-b: Move backward one word
bindkey -M viins '^B' backward-char        # C-b: Move backward one char
bindkey -M viins '^F' forward-char         # C-f: Move forward one char

# Normal Mode (vicmd)
bindkey -M vicmd '^A' beginning-of-line
bindkey -M vicmd '^E' end-of-line
bindkey -M vicmd '^K' kill-line
bindkey -M vicmd '^U' backward-kill-line
bindkey -M vicmd '^W' backward-kill-word
bindkey -M vicmd '^[d' kill-word
bindkey -M vicmd '^[f' forward-word
bindkey -M vicmd '^[b' backward-word
bindkey -M vicmd '^B' backward-char
bindkey -M vicmd '^F' forward-char

WORDCHARS='*?_[]~=&;!#$%^(){}<>|'

# Move forward to the beginning of the next word (non-space sequence)
forward-whole-string() {
  local len=${#BUFFER}
  # Skip the current word (if any)
  while (( CURSOR < len )); do
    if [[ "${BUFFER:$CURSOR:1}" == " " ]]; then
      break
    fi
    (( CURSOR++ ))
  done
  # Then skip over any whitespace to land at the start of the next word
  while (( CURSOR < len )); do
    if [[ "${BUFFER:$CURSOR:1}" != " " ]]; then
      break
    fi
    (( CURSOR++ ))
  done
  zle reset-prompt
}

# Move backward to the beginning of the previous word (non-space sequence)
backward-whole-string() {
  # First, if the character immediately left of the cursor is whitespace, skip it
  while (( CURSOR > 0 )); do
    if [[ "${BUFFER:$((CURSOR-1)):1}" != " " ]]; then
      break
    fi
    (( CURSOR-- ))
  done
  # Then, skip backwards over non-space characters until a space is encountered
  while (( CURSOR > 0 )); do
    if [[ "${BUFFER:$((CURSOR-1)):1}" == " " ]]; then
      break
    fi
    (( CURSOR-- ))
  done
  zle reset-prompt
}

# Register the functions
zle -N forward-whole-string
zle -N backward-whole-string

# Bindings
bindkey "^[^F" forward-whole-string  # Escape followed by Ctrl-F
bindkey "^[^B" backward-whole-string # Escape followed by Ctrl-B
bindkey -M vicmd "^[^F" forward-whole-string
bindkey -M vicmd "^[^B" backward-whole-string

# Tmux changes C-M-* keybindings input
if [[ -n "$TMUX" ]]; then
  bindkey -M viins '^[[27;7;102~' forward-whole-string
  bindkey -M viins '^[[27;7;98~' backward-whole-string
  bindkey -M vicmd '^[[27;7;102~' forward-whole-string
  bindkey -M vicmd '^[[27;7;98~' backward-whole-string
fi

# # Define helper to bind both Alt (Meta) and Cmd (Command) keys
# bind_both() {
#   local mode="$1" key="$2" cmd="$3"
#   # Alt-based binding (^[)
#   bindkey -M "$mode" "^[${key}" "$cmd"
#   # Command-based binding (macOS sends \e[27;9;<code>~)
#   # We'll handle common CMD+letter escape sequences via pattern
#   case "$key" in
#     [a-zA-Z])
#       local code=$(printf "%d" "'$key'")
#       bindkey -M "$mode" "^[[27;9;${code}~" "$cmd"
#       ;;
#   esac
# }
#
# # Example usage (for both viins and vicmd maps)
# for mode in viins vicmd; do
#   bind_both "$mode" "f" forward-word
#   bind_both "$mode" "b" backward-word
#   bind_both "$mode" "d" kill-word
# done
#
# # Now your custom word-motion bindings:
# zle -N forward-whole-string
# zle -N backward-whole-string
#
# for mode in viins vicmd; do
#   bind_both "$mode" "^F" forward-whole-string
#   bind_both "$mode" "^B" backward-whole-string
# done
