#!/bin/bash

NIRI_CONFIG="$HOME/.config/niri/config.kdl"

case $1 in
    "colemak")
        sed -i 's/variant.*/variant "colemak,"/' "$NIRI_CONFIG"
        sed -i 's/options.*/options "caps:swapescape,grp:shifts_toggle"/' "$NIRI_CONFIG"
        niri msg action load-config-file
        ;;
    "qwerty")
        sed -i 's/variant.*/variant ","/' "$NIRI_CONFIG"
        sed -i 's/options.*/options "grp:shifts_toggle"/' "$NIRI_CONFIG"
        niri msg action load-config-file
        ;;
    *)
        echo "Usage: $0 {colemak|qwerty}"
        exit 1
        ;;
esac
