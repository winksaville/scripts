#!/usr/bin/env bash

set -euo pipefail
#set -x

if [ $# == 0 ]; then
	echo "First parameter must be version, example: v2.1.0"
	exit 1
fi

# Parameter 1 is the version
ver=$1

# Get the tar, untar and make the file executable
niceit curl -f -L https://github.com/sigp/lighthouse/releases/download/$ver/lighthouse-$ver-x86_64-unknown-linux-gnu.tar.gz -o ~/bin/lighthouse-$ver-x86_64-unknown-linux-gnu.tar.gz
niceit tar -xf ~/bin/lighthouse-$ver-x86_64-unknown-linux-gnu.tar.gz -O > ~/bin/lighthouse-$ver
niceit chmod a+x ~/bin/lighthouse-$ver

# Make curent using remove and copy works even if bn and vc's are running.
#   See: https://unix.stackexchange.com/questions/404551/overwriting-a-running-executable-or-so
niceit rm -f ~/bin/lighthouse
niceit ln -s ~/bin/lighthouse-v2.1.0 ~/bin/lighthouse

echo Done
