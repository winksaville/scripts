#!/usr/bin/env bash

# Enable error options, but don't error on exit, i.e. no -e
set -Euo pipefail

# Enable debug
#set -x

/home/kendall/bin/reth db drop \
  --chain holesky \
  --instance 1 \
  --datadir /home/kendall/eth2-data/reth/holesky \
  --log.file.format terminal \
  --log.file.filter debug \
  --log.file.directory /home/kendall/eth2-data/reth \
  --log.file.max-size 200 \
  --log.file.max-files 5 \
  --log.journald \
  --log.journald.filter error \
  --color auto \

