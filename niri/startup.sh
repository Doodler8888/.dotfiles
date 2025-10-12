#!/usr/bin/env bash

# Give Niri a short moment to initialize fully
sleep 1

# Workspace 1: Brave
niri msg action focus-workspace "1-browser"
niri msg action spawn -- "brave-browser"
sleep 1.5
niri msg action maximize-column

sleep 1.5
# niri msg action toggle-windowed-fullscreen

# Workspace 2: Foot terminal
niri msg action focus-workspace "2-alt-browser"
niri msg action spawn -- "vivaldi-stable"
sleep 0.5
niri msg action maximize-column

sleep 2
# niri msg action toggle-windowed-fullscreen

# Workspace 3: Vivaldi
niri msg action focus-workspace "3-terminal"
niri msg action spawn -- "foot"
sleep 0.5
niri msg action maximize-column
niri msg action toggle-windowed-fullscreen

sleep 2
# niri msg action toggle-windowed-fullscreen

# Workspace 4: Telegram
niri msg action focus-workspace "4-chat"
niri msg action spawn -- "Telegram"
sleep 1.3
niri msg action maximize-column

sleep 1.5
# niri msg action toggle-windowed-fullscreen

# Return to workspace 1 at the end
niri msg action focus-workspace "2-alt-browser"
