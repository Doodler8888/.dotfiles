#!/bin/bash

# Function to run a command and wait for the window to appear
wait_for_window() {
    i3-msg "exec $1"
    sleep 2
}

# Switch to workspace 3
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

# Mark the main container if needed
i3-msg 'mark main'

# Switch back to the first workspace (optional)
i3-msg 'workspace 1'

