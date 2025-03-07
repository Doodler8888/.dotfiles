# export FZF_DEFAULT_OPTS="--bind 'ctrl-v:execute-silent(echo {} | wl-copy)'"
export FZF_DEFAULT_OPTS="--bind 'ctrl-v:execute-silent(echo {} | wl-copy && notify-send \"Copied to clipboard\" \"$(echo {} | fold -w 50)\")'"

