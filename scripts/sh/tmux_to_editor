#!/bin/sh

tmux_to_editor() {
    file=$(mktemp)
    # Capture pane content, remove empty lines, and save to the file
    tmux capture-pane -pS -32768 | grep -v '^[[:space:]]*$' > "$file"
    tmux new-window -n mywindow "nvim '+ normal G $' $file"
}

# Call the function
tmux_to_editor
