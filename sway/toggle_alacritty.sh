#!/bin/bash

TERM_ID="alacritty_float"

# Check if the terminal is running
if pgrep -f "alacritty --class=$TERM_ID" > /dev/null; then
    # Check if it's visible
    if swaymsg -t get_tree | grep -q "\"app_id\":\"$TERM_ID\",\"visible\":true"; then
        # Hide it
        swaymsg "[app_id=\"$TERM_ID\"] move scratchpad"
    else
        # Show it
        swaymsg "[app_id=\"$TERM_ID\"] scratchpad show"
    fi
else
    # Start a new one
    nohup alacritty --class=$TERM_ID > /dev/null 2>&1 &
fi
