#!/usr/bin/env bash

# Exit on errors
set -eu -o pipefail

mkdir -p ~/.config
mkdir -p ~/.ssh
cp ~/scripts/bashrc ~/.bashrc
cp ~/scripts/bash_profile ~/.bash_profile
cp ~/scripts/gitconfig ~/.gitconfig
cp ~/scripts/vimrc ~/.vimrc
cp -r ~/scripts/vim ~/.vim
cp -r ~/scripts/nvim ~/.config/
cp -r ~/scripts/ssh/config ~/.ssh/config
chmod 600 ~/.ssh/config

