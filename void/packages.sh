#!/bin/sh

sudo xbps-install -Su linux-firmware-amd mesa-dri xorg vulkan-loader \
mesa-vulkan-radeon mesa-vaapi mesa-vdpau opendoas noto-fonts-emoji gcc \
clang cmake firefox dbus seatd gettext xdg-utils wl-clipboard ripgrep \
dolphin lua-language-server htop shellcheck slurp grim

echo "Installing for compiling emacs..."

sudo xbps-installautoconf texinfo ImageMagick libmagick-devel gtk+3-devel \
libgccjit-devel tree-sitter-devel ncurses-libtinfo-devel libnotify
