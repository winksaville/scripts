#!/usr/bin/env bash

# Enable error options
set -Eeuo pipefail

# Enable debug
#set -x

if [ $# == 0 ]; then
	echo 'First parameter is journalctl `--since` parameter;'
	echo 'such as -1d or "2024-02-01 14:48:38"'
	exit 1
fi

# Parameter 1 is the version
ver=$1

failed=`niceit journalctl -u beacon-chain.service --since "$1" | rg "attestation.*failed" | wc -l`
success=`niceit journalctl -u beacon-chain.service --since "$1" | rg "attestation.*success" | wc -l`
ratio=`echo "scale=2; $failed/$success" | bc`

echo ratio:$ratio = failed:$failed / success:$success

