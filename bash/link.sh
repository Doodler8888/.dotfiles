#!/bin/bash

rm ~/.bashrc
rm ~/.inputrc

ln -s "$HOME/.dotfiles/bash/.bashrc" "$HOME/"
ln -s "$HOME/.dotfiles/bash/.inputrc" "$HOME/"
