#!/usr/bin/env bash

# Enable error options
set -Eeuo pipefail

# Enable debug
# set -x

if (( $# < 3 )); then
  echo "Usage: $(basename $0)"
  echo "  $(basename $0) <cmd to execute> <number of parallel jobs> <param1> <param2> ..."
  exit 1;
fi

cmd_to_execute=$1
parallel_jobs=$2
shift 2

function parallel {
  xargs -I{} --max-procs $parallel_jobs bash -c "$cmd_to_execute {}" ; echo "Exit code for xargs = $?"
}

for PARAM in $@; do echo $PARAM; done | parallel
