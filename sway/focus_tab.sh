#!/bin/bash

# The tab number to focus on
tab_number=$1

# Get the current workspace
current_workspace=$(swaymsg -t get_workspaces | jq '.[] | select(.focused==true).num')

# Focus on the specified tab
swaymsg workspace $current_workspace; focus child $tab_number
