while true; do date "+%H:%M:%S: " | tr -d "\n" ; traceroute -n $1; sleep $2; done
