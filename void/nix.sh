#!/bin/sh

set -e

sudo xbps-install -Sy nix
sudo ln -s /etc/sv/nix-daemon /var/service
source /etc/profile
nix-channel --add http://nixos.org/channels/nixpkgs-unstable
nix-channel --update

echo "Testing by instantiating the hello package..."

nix-instantiate '<nixpkgs>' -A hello

echo "Try to reboot first if something is wrong"

echo "Adding source for home-manager"

nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

echo "Installing home-manager"
nix-shell '<home-manager>' -A install

echo "Linking home-manager directory to ~/.config"
rm -rf ~/.config/home-manager/
ln -s ~/.dotfiles/home-manager/ ~/.config/
