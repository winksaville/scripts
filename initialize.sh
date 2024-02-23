#!/usr/bin/env bash

# Enable error options
set -Eeuo pipefail

# Enable debug
#set -x

mkdir -p ~/.config
mkdir -p ~/.ssh
cp ~/scripts/bashrc ~/.bashrc
cp ~/scripts/bash_profile ~/.bash_profile
cp ~/scripts/gitconfig ~/.gitconfig
cp ~/scripts/vimrc ~/.vimrc
cp -r ~/scripts/vim ~/.vim/
cp -r ~/scripts/nvim ~/.config/

mkdir -p ~/.config/terminator
cp ~/scripts/config-terminator-config ~/.config/terminator/config

cp ~/scripts/ssh/* ~/.ssh/
chmod 600 ~/.ssh/config
echo "copy important/git-commit-keys to .ssh/ 'cp ~/<path/to/git-commit-keys/* ~/.ssh/'"

mkdir -p ~/bin
cp ~/scripts/update-lighthouse.sh ~/bin/
cp ~/scripts/remove-all-from-docker.sh ~/bin/
cp ~/scripts/screensaver-lock-display-off ~/bin/
cp ~/scripts/mbvc.sh ~/bin
cp ~/scripts/missing-failed-success-ratio.sh ~/bin

# rpi38 is the time server and and a different file is used
[[ "$HOSTNAME" = "rpi38" && -f /etc/chrony.conf ]] && ( sudo cp ~/scripts/chrony.conf.rpi38 /etc/chrony.conf )
[[ "$HOSTNAME" = "rpi38" && -f /etc/chrony/chrony.conf ]] && ( sudo cp ~/scripts/chrony.conf.rpi38 /etc/chrony/chrony.conf )

# All other devices "use-rpi38"
[[ "$HOSTNAME" != "rpi38" && -f /etc/chrony.conf ]] && ( sudo cp ~/scripts/chrony.conf.use-rpi38 /etc/chrony.conf )
[[ "$HOSTNAME" != "rpi38" && -f /etc/chrony/chrony.conf ]] && ( sudo cp ~/scripts/chrony.conf.use-rpi38 /etc/chrony/chrony.conf )

