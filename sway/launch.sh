# #!/bin/bash


# Your existing script to set up workspaces and launch applications
# Create a tabbed container on workspace 1 and assign Alacritty instances to it
swaymsg 'workspace 1'
# swaymsg 'layout tabbed'
swaymsg 'exec opera'

sleep 2

# Create a tabbed container on workspace 2 and assign browsers to it
swaymsg 'workspace 2'
# swaymsg 'layout tabbed'
swaymsg 'exec vivaldi-stable'
# swaymsg 'exec alacritty'

sleep 2


# Move to workspace 3 and set layout to tabbed
swaymsg 'workspace 3'
swaymsg 'layout tabbed'

# Launch the first Emacs instance and load the "main" desktop session
swaymsg 'exec alacritty'

# Wait for Emacs to launch
sleep 2

# Split the layout vertically, launch Alacritty, and set layout to stacking
swaymsg 'splitv'
swaymsg 'exec emacs --eval "(load-desktop-session \"main\")"'
swaymsg 'layout stacking'

# Wait for Alacritty to launch
sleep 2

# Focus the parent container (tab) and set layout back to tabbed
swaymsg 'focus parent'
swaymsg 'layout tabbed'

# Launch the second Emacs instance and load the "shelf" desktop session
swaymsg 'exec alacritty'

# Wait for Emacs to launch
sleep 2

# Split the layout vertically, launch Alacritty, and set layout to stacking
swaymsg 'splitv'
swaymsg 'exec emacs --eval "(load-desktop-session \"shelf\")"'
swaymsg 'layout stacking'

sleep 2

swaymsg 'workspace 4'
swaymsg 'exec telegram-desktop'

swaymsg 'workspace 3'
