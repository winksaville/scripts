#!/usr/bin/env bash
# Backup a file
# The first parameter is the source file
# the destintion is the 

# Enable error options
set -Eeuo pipefail

[[ $# == 0 ]] && ( echo "Usage: backup <parameter 1> to (<parameter 1>|<parameter 2>).date-time.microsecsZ.backup"; exit 1; )

# Source is always the first parameter
src=$1
#echo src=$src

# Destination is either $1 or $2 if present
# in either case the time and .backup are appended
dst=${2:-$1}
#echo dst=$dst

now_secs_usecs_utc() {
	date -u +"%Y%m%dT%H%M%S.%N"Z
}

backup_file() {
	cp "$src" "$dst-$(now_secs_usecs_utc).backup"
}

backup_file $@
