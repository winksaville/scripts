#!/usr/bin/env bash
# Bash and basic stuff like vim nvim

# Enable debug
#set -x

#echo "init-bash.sh:+"

mkdir -p ~/.config
mkdir -p ~/.vim
cp ~/scripts/bashrc ~/.bashrc
cp ~/scripts/bash_profile ~/.bash_profile
cp ~/scripts/vimrc ~/.vimrc
cp -r ~/scripts/vim ~/.vim/
cp -r ~/scripts/nvim ~/.config/
if [ ! "$(command -v vi)" ]; then sudo ln -s /usr/bin/vim /usr/bin/vi; fi

# Used by shfmt
cp ~/scripts/editorconfig ~/.editorconfig

#echo "init-bash.sh:-"

