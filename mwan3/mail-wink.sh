#!/bin/sh
# $1 is email@address.com
# $2 is subject
# $3 is message

mailsend -smtp smtp.gmail.com \
-port 587 \
-starttls \
-f wink@saville.com \
+cc +bc \
-auth-login \
-user wink@saville.com \
-pass 'hlkdytgjowvkayki' \
-t "$1" \
-sub "$2" \
-M "$3"
