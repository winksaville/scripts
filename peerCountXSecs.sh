while true; do date "+%H:%M:%S: " | tr -d "\n" ; ~/bin/peerCount.sh; sleep $1; done
