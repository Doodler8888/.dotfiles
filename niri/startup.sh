#!/usr/bin/env bash

# Give Niri a short moment to initialize fully
sleep 2

# Workspace 1: Brave
niri msg action focus-workspace "1-browser"
niri msg action spawn -- "brave-browser"

sleep 3

# Workspace 2: Foot terminal
niri msg action focus-workspace "2-alt-browser"
niri msg action spawn -- "vivaldi-stable"

sleep 3
# niri msg action toggle-windowed-fullscreen

# Workspace 3: Vivaldi
niri msg action focus-workspace "3-terminal"
niri msg action spawn -- "emacs"
sleep 0.5
# Create tmux session if it doesn't exist
niri msg action spawn-sh -- "tmux new-session -d -s main || true"
sleep 0.5
# Launch Foot restoring tmux resurrect
niri msg action spawn-sh -- "foot -e tmux run-shell ~/.tmux/plugins/tmux-resurrect/scripts/restore.sh"
sleep 1
# Attach to tmux session
niri msg action spawn-sh -- "foot -e tmux attach-session -t main"
sleep 1
niri msg action maximize-column
niri msg action toggle-windowed-fullscreen

sleep 2

# Workspace 4: Telegram
niri msg action focus-workspace "4-chat"
niri msg action spawn -- "Telegram"

sleep 3

# Workspace 4: VPN
niri msg action focus-workspace "5-vpn"
niri msg action spawn-sh -- "/usr/lib/pritunl_client_electron/Pritunl --gtk-version=3"

sleep 3

# Return to workspace 1 at the end
# niri msg action focus-workspace "2-alt-browser"
