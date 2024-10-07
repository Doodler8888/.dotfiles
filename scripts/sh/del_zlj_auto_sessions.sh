#!/bin/bash

# Get current user
current_user=$(whoami)
echo "Script is being executed by user: $current_user"

# List and filter Zellij sessions
sessions=$(zellij list-sessions | awk '/EXITED/ && ($1 ~ /-/) {print $1}' | sed -e 's/\x1b\[[0-9;]*m//g')

# Read each session name and delete it
while IFS= read -r session; do
    zellij delete-session "$session"
    echo "This is a session name that was killed: $session"
done <<< "$sessions"
