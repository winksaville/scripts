#!/usr/bin/env bash

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

if [ $(command -v ~/bin/reth) ]; then printf "\n~/bin/reth --version:\n"; ~/bin/reth --version; fi
if [ $(command -v geth) ]; then printf "\ngeth version:\n"; geth version; fi
if [ $(command -v ~/bin/lighthouse) ]; then printf "\n~/bin/lighthouse --version:\n"; ~/bin/lighthouse --version; fi
printf "\ninxi:\n"; inxi
printf "\nlsb_release -a:\n"; lsb_release -a
printf "\ndf -h:\n"; df -h
if [ $(command -v apt) ]; then printf "\napt list --upgradeable:\n"; apt list --upgradeable; fi
if [ $(command -v checkupdates) ]; then
	printf "\ncheckupdates:\n"
	if ! checkupdates; then
		echo "Nothing to update or an error"
	fi
fi

# Print uptime=load, free-memory, smartctl=nvme temps and sensors=cpu temps
printf "\nuptime:\n"
uptime
printf "\nfree:\n"
free -h

# sensors and smartctl need refining as different devices
# print different stuff, but good enough for now.
printf "\nsensors:\n"
sensors | rg "temp|Core|Package"
printf "\nsmartctl:\n"
sudo smartctl -a /dev/nvme0n1 | rg "Temperature:|Temp.*Sen"

