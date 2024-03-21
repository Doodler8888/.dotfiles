#!/bin/bash

# Create a tabbed container on workspace 1 and assign Alacritty instances to it
swaymsg 'workspace 1'
swaymsg 'layout tabbed'
for _ in {1..4}; do
    swaymsg 'exec alacritty'
done

sleep 1

# Create a tabbed container on workspace 2 and assign browsers to it
swaymsg 'workspace 2'
swaymsg 'layout tabbed'
swaymsg 'exec opera'
swaymsg 'exec vivaldi-stable'

# sleep 1

# swaymsg 'workspace 3'
# swaymsg 'layout tabbed'
# emacs -nw --eval "(load-desktop-session \"main\")"
# emacs -nw --eval "(load-desktop-session \"shelf\")"

