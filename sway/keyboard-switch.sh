#!/bin/bash

case $1 in
    "colemak")
        swaymsg "input * xkb_layout \"us,ru\""
        swaymsg "input * xkb_variant \"colemak,\""
        swaymsg "input * xkb_options \"caps:swapescape,grp:shifts_toggle\""
        ;;
    "qwerty")
        swaymsg "input * xkb_layout \"us,ru\""
        swaymsg "input * xkb_variant \",\""
        swaymsg "input * xkb_options \"grp:shifts_toggle\""  # Removed caps:swapescape
        ;;
esac
