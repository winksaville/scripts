#!/bin/sh
# Expecting two or three parameters
#   $1 is email@address.com
#   $2 is message
#
#   $1 is email@address.com
#   $2 is subject
#   $3 is message

COMMAND="mailsend -smtp smtp.gmail.com -port 587 -starttls -f wink@saville.com +cc +bc -auth-login -user wink@saville.com -pass hlkdytgjowvkayki -t $1"

echo COMMAND=$COMMAND -M "$2"

case $# in
  2)
    $COMMAND -sub " " -M "$2"
    STATUS=$?
    ;;
  3)
    $COMMAND -sub "$2" -M "$3"
    STATUS=$?
    ;;
  *)
    echo "Expecting 2 parameters"
    echo "  $0 <address> <message>"
    echo "or 3 parameters"
    echo "  $0 <address> <subject> <message>"
    STATUS=255
esac

exit $STATUS
