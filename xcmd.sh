#!/usr/bin/env bash

# Enable error options
set -Eeuo pipefail

# Enable debug
#set -x

echo "xcmd proc_id=$1"
sleep $[RANDOM % 5]
echo "Done $1"
