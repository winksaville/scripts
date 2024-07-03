#!/usr/bin/env bash
# Move one or more validators from source to destination

# Enable error options
set -Eeuo pipefail

# Enable debug
#set -x

# Some default assumptions maybe make as optional parameters in the future.
port=5062
dir=~/api-tokens/mainnet-validators

# debug
#echo "\$#=$#"

if (( $# < 2 )) then
    filename=$(basename $0)
    echo "Usage: $filename <src_vc> <dst_vc> <other>"
    echo "  src_vc:    Source domain assumes port $port example: name@computerA"
    echo "  dst_vc:    Destination domain assumes port $port example: name@computerB"
    echo "  other:     All other parameters are passed as is, these could include:"
    echo "               --validators {all|publlic_keys}"
    echo "               --count <vc_count>"
    echo "             Use 'lighthouse vm move --help' for other parameters"
    echo
    echo "  Assumes:   tokens are in directory = $dir/"
    exit 1
fi

src_vc=$1
shift
dst_vc=$1
shift
other=$@

if [ ! -f $dir/$src_vc.api-token.txt ]; then echo "$dir/$src_vc.api-token.txt NOT FOUND"; exit 1; fi
if [ ! -f $dir/$dst_vc.api-token.txt ]; then echo "$dir/$dst_vc.api-token.txt NOT FOUND"; exit 1; fi

# debug
#echo src_vc="$src_vc" dst_vc="$dst_vc" other="$other"
#echo port="$port"
#echo dir="$dir"
#ls $dir

lighthouse vm move \
  --src-vc-token $dir/$src_vc.api-token.txt \
  --src-vc-url http://kendall@$src_vc:$port \
  --dest-vc-token $dir/$dst_vc.api-token.txt \
  --dest-vc-url http://kendall@$dst_vc:$port \
  $other

