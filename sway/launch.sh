#!/usr/bin/env bash

# Your existing script to set up workspaces and launch applications
# Create a tabbed container on workspace 1 and assign Alacritty instances to it
swaymsg 'workspace 1'
# swaymsg 'layout tabbed'
# swaymsg 'exec opera --enable-features=UseOzonePlatform --ozone-platform=wayland'
swaymsg 'exec opera'

sleep 2

# Create a tabbed container on workspace 2 and assign browsers to it
swaymsg 'workspace 2'
# swaymsg 'layout tabbed'
# swaymsg 'exec vivaldi-stable'
swaymsg 'exec vivaldi.vivaldi-stable'
# swaymsg 'exec /usr/bin/vivaldi'
>>>>>>> Stashed changes
# swaymsg 'exec vivaldi --enable-features=UseOzonePlatform --ozone-platform=wayland'
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
# swaymsg 'exec /home/wurfkreuz/.nix-profile/bin/emacs'
swaymsg 'exec emacs'
# swaymsg exec '/home/wurfkreuz/common-lisp/lem/lem --interface "sdl2"'
# swaymsg 'exec emacs --eval "(load-desktop-session \"main\")"'
swaymsg 'layout stacking'

sleep 2

# Tab 2
swaymsg 'focus parent'
swaymsg 'layout tabbed'
swaymsg 'mark main'

# swaymsg 'exec alacritty'
swaymsg 'exec alacritty -e zellij'

# # Wait for Emacs to launch
sleep 2

# # Split the layout vertically, launch Alacritty, and set layout to stacking
swaymsg 'splitv'
swaymsg 'exec alacritty -e zellij attach main'
# swaymsg 'exec /usr/bin/alacritty -e /home/wurfkreuz/.cargo/bin/zellij attach main'
swaymsg 'layout stacking'

sleep 2

swaymsg 'workspace 4'
swaymsg 'exec telegram-desktop'
# swaymsg 'exec telegram'

swaymsg 'workspace 3'
