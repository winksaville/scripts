#!/usr/bin/env bash
# Move one or more validators from source to destination

# Enable error options
set -Eeuo pipefail

# Enable debug
#set -x

echo "\$#=$#"
if (( $# < 3 )) then
    filename=$(basename $0)
    echo "Usage: $filename <src_vc> <dest_vc> <other>"
    echo "  src_vc:    Source domain assumes port 5062 example: name@computerA"
    echo "  dest_vc:   Destination domain assumes port 5062 example: name@computerA"
    echo "  other:     All other parameters passed as is, these could include:"
    echo "               --validators {all|publlic_keys}"
    echo "               --count <vc_count>"
    echo "             Use 'lighthouse vm move --help' for other parameters"
    exit 1
fi

src_vc=$1
shift
dest_vc=$1
shift
other=$@

lighthouse vm move \
  --src-vc-token ~/api-token/$src_vc.api-token.txt \
  --src-vc-url http://kendall@$src_vc:5062 \
  --dest-vc-token ~/api-token/$dest_vc.api-token.txt \
  --dest-vc-url http://kendall@$dest_vc:5062 \
  $other

