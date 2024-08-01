#!/usr/bin/env bash

VERSION=v0.1.0

# More strigent errors handling
# -E      If set, any trap on ERR is inherited by shell functions, command substitutions, and commands executed in a subshell environment.
#         The ERR trap is normally not inherited in such cases.
# -e      Exit immediately if a pipeline (which may consist of a single simple command), a list, or a compound command (see SHELL  GRAMMAR
#         above), exits with a non-zero status. (Lots of exceptions see `man bash`)
# -u      Treat  unset variables and parameters other than the special parameters "@" and "*" as an error when performing parameter expansion.
# -o      pipefail: When set, the return value of a pipeline is the value of the last (rightmost) command to exit
#         with a non-zero status, or zero if all commands in the pipeline exit successfully.
set -Eeuo pipefail

# Enable debug:
#set -x

# Function to display usage information
usage() {
  echo "Usage: $0 <device>  # device: such as; nvme0n1 or sda"
  echo "Version: $VERSION"
  exit 1
}

echo count="$#"

# Check if the correct number of arguments are provided
if [ "$#" -ne 1 ]; then
  usage
fi

NVME_DEV=$1

# sensors and smartctl need refining as different devices
# print different stuff, but good enough for now.
printf "\nsensors:\n"
sensors | rg "temp|Core|Package"

printf "\nsmartctl:\n"
sudo smartctl -a "/dev/$NVME_DEV" | rg -i "Temperature:|Temp.*Sen|^Data |^Host "

