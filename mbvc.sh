#!/usr/bin/env bash

# Enable error options
set -Eeuo pipefail

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

