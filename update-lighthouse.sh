#!/usr/bin/env bash

# Enable error options, but don't error on exit, i.e. no -e
set -Euo pipefail

# Enable debug
#set -x

if [ $# == 0 ]; then
	echo "First parameter must be version, example: v2.1.0"
	exit 1
fi

# Parameter 1 is the version
ver=$1

# Get a file and extract
# $1 = filename
# $2 = extension
function get_file_and_extract () {
  file_name=$1
  extension=$2
  tripple=$(gcc -dumpmachine -m)
  case $tripple in
    x86_64-linux-gnu)
      tripple=x86_64-unknown-linux-gnu
      ;;
    x86_64-pc-linux-gnu)
      tripple=x86_64-unknown-linux-gnu
      ;;
    aarch64-unknown-linux-gnu)
      # Good as is tripple=aarch64-unknown-linux-gnu
      ;;
    *)
      echo "Error: unknown architecture tripple of $tripple"
      exit 1
      ;;
  esac
  full_file_name=$file_name-$tripple$extension
  niceit curl -f -L https://github.com/sigp/lighthouse/releases/download/$ver/$full_file_name -o ~/bin/$full_file_name
  rslt=$?
  #echo "rslt=$rslt"
  if [ $rslt -eq 0 ]; then
    echo "success $full_file_name downloaded"
    niceit tar -xf ~/bin/$full_file_name -O > ~/bin/$file_name
    rslt=$?
    if [ $rslt -eq 0 ]; then
      echo "success extracted $full_file_name to $file_name"
      return 0
    else
      echo "Couldn't extract $full_file_name rslt=$rslt"
      return $rslt
    fi
  else
    echo "curl failed getting $full_file_name rslt=$rslt"
    return $rslt
  fi
}

# Try .tar.gz first
get_file_and_extract lighthouse-$ver .tar.gz
rslt=$?
if [ $rslt -ne 0 ]; then
  # Try just ".tar" extension
  get_file_and_extract lighthouse-$ver .tar
  rslt=$?
  if [ $rslt -ne 0 ]; then
    exit $?
  fi
fi

# Enable exit on error
set -e
niceit chmod a+x ~/bin/lighthouse-$ver

# Make curent using remove and copy works even if bn and vc's are running.
#   See: https://unix.stackexchange.com/questions/404551/overwriting-a-running-executable-or-so
niceit rm -f ~/bin/lighthouse
niceit ln -s ~/bin/lighthouse-$ver ~/bin/lighthouse

echo Done
