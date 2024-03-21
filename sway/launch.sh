# #!/bin/bash


# Your existing script to set up workspaces and launch applications
# Create a tabbed container on workspace 1 and assign Alacritty instances to it
swaymsg 'workspace 1'
swaymsg 'layout tabbed'
swaymsg 'exec opera'

sleep 1

# Create a tabbed container on workspace 2 and assign browsers to it
swaymsg 'workspace 2'
swaymsg 'layout tabbed'
swaymsg 'exec vivaldi-stable'
swaymsg 'exec alacritty'

sleep 2


# Move to workspace 3 and set layout to tabbed
swaymsg 'workspace 3'
swaymsg 'layout tabbed'

# Launch the first Emacs instance and load the "main" desktop session
swaymsg 'exec emacs --eval "(load-desktop-session \"main\")"'

# Wait for Emacs to launch
sleep 2

# Split the layout vertically, launch Alacritty, and set layout to stacking
swaymsg 'splitv'
swaymsg 'exec alacritty'
swaymsg 'layout stacking'

# Wait for Alacritty to launch
sleep 2

# Focus the parent container (tab) and set layout back to tabbed
swaymsg 'focus parent'
swaymsg 'layout tabbed'

# Launch the second Emacs instance and load the "shelf" desktop session
swaymsg 'exec emacs --eval "(load-desktop-session \"shelf\")"'

# Wait for Emacs to launch
sleep 2

# Split the layout vertically, launch Alacritty, and set layout to stacking
swaymsg 'splitv'
swaymsg 'exec alacritty'
swaymsg 'layout stacking'

# swaymsg "workspace 3; append_layout /home/wurfkreuz/.dotfiles/sway/layout.json"

# # Launch the first application (e.g., Emacs) into the first tab's stacking container
# swaymsg "workspace 3; exec emacs"
# # Wait for the application to launch
# sleep 2

# # Launch Alacritty into the same tab's stacking container
# swaymsg "workspace 3; exec alacritty"
# # Wait for the application to launch
# sleep 2

# # Focus moves to the next tab automatically after the first is populated
# # Launch the second application (e.g., another instance of Emacs) into the second tab's stacking container
# swaymsg "workspace 3; exec emacs"
# # Wait for the application to launch
# sleep 2


# # Move to workspace 3 and set layout to tabbed
# swaymsg 'workspace 3'
# swaymsg 'layout tabbed'

# # Launch Alacritty into the same tab's stacking container
# swaymsg "workspace 3; exec alacritty"

# # Launch the first Emacs instance and load the "main" desktop session
# emacs --eval "(load-desktop-session \"main\")" &
# # Wait for Emacs to launch
# sleep 2

# # Split the layout vertically, launch Alacritty, and set layout to stacking
# swaymsg 'splitv'
# swaymsg 'exec alacritty'
# swaymsg 'layout stacking'
# # Wait for Alacritty to launch
# sleep 2

# # Launch the second Emacs instance and load the "shelf" desktop session
# emacs --eval "(load-desktop-session \"shelf\")" &
# # Wait for Emacs to launch
# sleep 2

# # Again, split the layout vertically, launch Alacritty, and set layout to stacking
# swaymsg 'splitv'
# swaymsg 'exec alacritty'
# swaymsg 'layout stacking'




# # Create a tabbed container on workspace 1 and assign Alacritty instances to it
# swaymsg 'workspace 1'
# # swaymsg 'layout tabbed'
# swaymsg 'exec opera'
# # for _ in {1..4}; do
# #     swaymsg 'exec alacritty'
# # done
