#!/usr/bin/env bash

# Create a tabbed container on workspace 1 and assign Opera to it
i3-msg 'workspace 1'
# i3-msg 'layout tabbed'
i3-msg 'exec opera'

sleep 2

# Create a tabbed container on workspace 2 and assign browsers to it
i3-msg 'workspace 2'
# i3-msg 'layout tabbed'
# i3-msg 'exec vivaldi-stable'
i3-msg 'exec vivaldi' # Just 'vivaldi' on nixos.
# i3-msg 'exec alacritty'

sleep 2

# Tab 1
i3-msg 'workspace 3'
i3-msg 'layout tabbed'

# i3-msg 'exec alacritty -e zellij attach main'
i3-msg 'exec alacritty -e zellij'
# i3-msg 'exec alacritty'

# Wait for Emacs to launch
sleep 2

# Split the layout vertically, launch Alacritty, and set layout to stacking
i3-msg 'splitv'
# i3-msg 'exec emacs'
i3-msg 'exec emacs --eval "(load-desktop-session \"main\")"'
i3-msg 'layout stacking'

sleep 2

# Tab 2
i3-msg 'focus parent'
i3-msg 'layout tabbed'
i3-msg 'mark main'

# i3-msg 'exec alacritty -e zellij attach cli'
i3-msg 'exec alacritty -e zellij'
# i3-msg 'exec alacritty'

# Wait for Emacs to launch
sleep 2

# Split the layout vertically, launch Alacritty, and set layout to stacking
i3-msg 'splitv'
# i3-msg 'exec emacs --eval "(load-desktop-session \"python-server\")"'
i3-msg 'exec alacritty -e zellij attach main'
i3-msg 'layout stacking'

sleep 2

# Tab 3
# i3-msg 'focus parent'
# i3-msg 'layout tabbed'
# i3-msg 'mark cli'
#
# i3-msg 'exec alacritty -e zellij attach main'
# # i3-msg 'exec alacritty -e zellij'
#
# sleep 2

i3-msg 'workspace 4'
i3-msg 'exec telegram-desktop'

i3-msg 'workspace 3'
