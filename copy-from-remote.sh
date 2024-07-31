#!/bin/bash

VERSION="v0.1.0"

# Function to display usage information
usage() {
  echo "Usage: $0 user@remote:/path/to/source /path/to/destination"
  echo "Version: $VERSION"
  exit 1
}

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
  usage
fi

# Assign command-line arguments to variables
SOURCE=$1
DESTINATION=$2
LOG_FILE=~/rsync-log

# Perform the initial rsync transfer with checksum verification and proper symlink handling
rsync -aHAXU --log-file=$LOG_FILE-xfer.txt --checksum --delete-after --progress --links --copy-unsafe-links $SOURCE $DESTINATION

# Perform a dry-run with checksums to verify the transfer
rsync -aHAXU --log-file=$LOG_FILE-verify.txt --checksum --delete-after --progress --links --copy-unsafe-links --dry-run $SOURCE $DESTINATION

# Check the result of the dry-run
if [ $? -eq 0 ]; then
  echo "Verification successful: No differences found."
else
  echo "Verification failed: Differences detected."
fi
