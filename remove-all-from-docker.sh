#!/usr/bin/env bash
# A shell script to stop all containers and remove containers, images,
# volumes and networks, from:
#   https://gist.github.com/beeman/aca41f3ebd2bf5efbd9d7fef09eac54d#gistcomment-3756922

# Enable error options
set -Eeuo pipefail

# Enable debug
#set -x

docker stop $(docker ps -qa)
docker system prune -a
