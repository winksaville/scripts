#!/usr/bin/env bash
# From https://stackoverflow.com/a/37375502/4812090

# Enable error options
set -Eeuo pipefail

# Enable debug
# set -x

gitk_follow () {
  while (( "$#" )); do
    git log --pretty="" --name-status --follow $1;
    shift;
  done | awk '{print $NF}' | sort -u
}

# used as:
gitk -- $(gitk_follow $1)
