#!/bin/bash

if ! pgrep -x "swww-daemon" > /dev/null; then
    swww-daemon > /dev/null 2>/dev/null &
    swww img "$HOME/Downloads/images/68747470733a2f2f692e696d6775722e636f6d2f4c65756836776d2e676966.gif" > /dev/null 2>&1 &
fi
