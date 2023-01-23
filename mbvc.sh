#!/usr/bin/env bash

# Disable error options so we don't have to "install existing package".
# TODO: Actually we should test the "Already up to date" warning from the
#       git pull and return from `mp()` early.
#set -Eeuo pipefail

# Enable debug
set -x

mp () {
	cd $1
	git pull
	makepkg -sir
	cd ..
}

mp brave-bin
mp visual-studio-code-bin
mp google-chrome

