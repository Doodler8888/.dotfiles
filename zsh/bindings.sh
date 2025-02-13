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
bindkey -M vicmd '^[f' forward-word
bindkey -M vicmd '^[b' backward-word
bindkey -M vicmd '^B' backward-char
bindkey -M vicmd '^F' forward-char

WORDCHARS='*?_[]~=&;!#$%^(){}<>|'

# Modified functions for whole string movement
forward-whole-string() {
    local save_wordchars="$WORDCHARS"
    WORDCHARS='*?_-[]~=&;!#$%^(){}<>|'  # Include - and all other chars
    zle forward-word
    WORDCHARS="$save_wordchars"
}

backward-whole-string() {
    local save_wordchars="$WORDCHARS"
    WORDCHARS='*?_-[]~=&;!#$%^(){}<>|'  # Include - and all other chars
    zle backward-word
    WORDCHARS="$save_wordchars"
}

zle -N forward-whole-string
zle -N backward-whole-string

# # Your existing bindings remain the same
# bindkey -M viins '^[^F' forward-whole-string   # C-M-f: Jump over whole string
# bindkey -M viins '^[^B' backward-whole-string  # C-M-b: Jump back over whole string
# bindkey -M vicmd '^[^F' forward-whole-string
# bindkey -M vicmd '^[^B' backward-whole-string

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
