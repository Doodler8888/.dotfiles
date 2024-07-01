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


# Tab 1
swaymsg 'workspace 3'
swaymsg 'layout tabbed'

# swaymsg 'exec alacritty -e zellij attach main'
swaymsg 'exec alacritty -e zellij'
# swaymsg 'exec alacritty'

# # Wait for Emacs to launch
sleep 2

# # Split the layout vertically, launch Alacritty, and set layout to stacking
swaymsg 'splitv'
# swaymsg 'exec emacs'
swaymsg 'exec emacs --eval "(load-desktop-session \"main\")"'
swaymsg 'layout stacking'

sleep 2

# Tab 2
swaymsg 'focus parent'
swaymsg 'layout tabbed'
swaymsg 'mark main'

# swaymsg 'exec alacritty -e zellij attach cli'
swaymsg 'exec alacritty -e zellij'
# swaymsg 'exec alacritty'

# # Wait for Emacs to launch
sleep 2

# # Split the layout vertically, launch Alacritty, and set layout to stacking
swaymsg 'splitv'
swaymsg 'exec emacs --eval "(load-desktop-session \"devops\")"'
# swaymsg 'exec emacs'
swaymsg 'layout stacking'

sleep 2

# Tab 3
swaymsg 'focus parent'
swaymsg 'layout tabbed'
swaymsg 'mark cli'

swaymsg 'exec alacritty -e zellij attach main'
# swaymsg 'exec alacritty -e zellij'

sleep 2


swaymsg 'workspace 4'
swaymsg 'exec telegram-desktop'

swaymsg 'workspace 3'
