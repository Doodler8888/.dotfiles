#!/usr/bin/env bash

# Simple wait function
wait_for_window() {
    i3-msg "exec $1"
    sleep 2  # Adjust timing if needed
}

# Launch Opera in workspace 1
i3-msg 'workspace 1'
wait_for_window "opera"

# Launch Vivaldi in workspace 2
i3-msg 'workspace 2'
wait_for_window "vivaldi"

# Switch to workspace 3 and set up development environment
i3-msg 'workspace 3'

# Create the first tab
i3-msg 'split horizontal'
wait_for_window "alacritty -e zellij"
i3-msg 'split vertical'
wait_for_window "emacs"
i3-msg 'layout stacking'

# Create the second tab
i3-msg 'focus parent; split horizontal'
wait_for_window "alacritty -e zellij"
i3-msg 'split vertical'
wait_for_window "alacritty -e zellij attach main"
i3-msg 'layout stacking'

# Set the top-level layout to tabbed
i3-msg 'focus parent; layout tabbed'

# Launch Telegram in workspace 4
i3-msg 'workspace 4'
wait_for_window "telegram-desktop"

# Switch back to the first workspace
i3-msg 'workspace 3'
