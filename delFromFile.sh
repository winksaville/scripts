#!/bin/bash
# from: https://www.baeldung.com/linux/delete-files-listed-in-file
#
# Deletes files or directories listed as seperate lines in a file
# that is the first parameter. The files are assumed to have the
# full path or, if no path, then the current directory is assumed.

# Enable error options
set -Eeuo pipefail

# Enable debug
#set -x

TO_BE_DEL="$1"
IFS=""

# Loop ignoring empty lines
while read -r file ; do
    [[ -n "$file" ]] && rm -r "$file"
done < "$TO_BE_DEL"

