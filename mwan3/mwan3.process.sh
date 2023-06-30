#!/bin/sh
#
# Parameters for this script
#
# $ACTION
#      <ifup>         Is called by netifd and mwan3track.
#      <ifdown>       Is called by netifd and mwan3track.
#      <connected>    Is only called by mwan3track if tracking was successful.
#      <disconnected> Is only called by mwan3track if tracking has failed.
# $INTERFACE	Name of the interface an action relates to {e.g. "wan" or "wwan".
# $DEVICE	Physical device name of the interface the action relates to {e.g. "eth0" or "wwan0".
#               Note: On an ifdown event, $DEVICE is not available, use $INTERFACE instead.
#
# Further documentation can be found here:
# https://openwrt.org/docs/guide-user/network/wan/multiwan/mwan3#alertsnotifications

ACTION=$1
INTERFACE=$2
DEVICE=$3


DATE() {
  echo `/root/date-utc-nlf.sh`
}

DBG() {
  echo "$(DATE) $1" >> /root/mwan3.user.messages
}

INFO="[$(DATE)]: $HOSTNAME $ACTION $INTERFACE $DEVICE"
SUBJECT="$INFO"
MESSAGE="Body: $INFO"

email() {
  #DBG "email: $INFO"
  #DBG "email: before sleep $1"
  #/bin/sleep $1
  #DBG "email: after sleep $1"
  /root/mail-wink.sh wink@saville.com "$SUBJECT" "$MESSAGE"
  DBG "email: status=$? $INFO"
}

sms() {
  #DBG "sms: $INFO"
  #DBG "sms: before sleep $1"
  #/bin/sleep $1
  #DBG "sms: after sleep $1"
  /root/mail-wink.sh 8312342134@msg.fi.google.com "$INFO"
  DBG "sms: status=$? $INFO"
}

#DBG "$0: strt $ACTION $INTERFACE"

case $ACTION in
  ifup|ifdown|disconnecting|connecting)
    DBG "ignoring $INFO"
    ;;
  disconnected)
    email 0
    sms 0
    ;;
  connected)
    email 0
    sms 0
    ;;
  *)
    DBG "$0: Unknown ACTION=$ACTION $INTERFACE"
    ;;
esac

#DBG "$0: done $ACTION $INTERFACE"
