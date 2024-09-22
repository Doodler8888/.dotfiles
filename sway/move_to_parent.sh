#!/usr/bin/env bash

# case $1 in
#   moveToParent)
#     swaymsg mark i3ha
#     swaymsg focus parent
#     swaymsg focus parent
#     swaymsg mark i3hb
#     swaymsg [con_mark="i3ha"] focus
#     swaymsg move window to mark i3hb
#     swaymsg unmark i3ha
#     swaymsg unmark i3hb
#     ;;
# esac

case $1 in
 moveToParent)
    # Mark the current window
    swaymsg mark i3ha
    # Focus the parent container
    swaymsg focus parent
    # Split the parent container (this creates a new container)
    swaymsg splitv
    # Focus the new container
    swaymsg focus right
    # Move the marked window to the new container
    swaymsg [con_mark="i3ha"] move container to mark i3hb
    # Unmark the window
    swaymsg unmark i3ha
    ;;
esac

