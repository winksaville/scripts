#!/usr/bin/env bash
# Launches socat+npiperelay to relay the gpg-agent socket file for use in WSL
# See https://justyn.io/blog/using-a-yubikey-for-gpg-in-windows-10-wsl-windows-subsystem-for-linux/ for details

# Enable error options
set -Eeuo pipefail

# Enable debug
# set -x


GPGDIR="${HOME}/.gnupg"
PIDHISTORY="${GPGDIR}/gpg-agent-relay.pid.history"
#LOGFILE="$GPGDIR/gpg-agent-relay.log"
LOGFILE=/dev/stdout

# I use the same username for wsl and windows
USERNAME=wink
echo $$ >> ${PIDHISTORY}

WIN_GPGDIR="C:/Users/${USERNAME}/AppData/Roaming/gnupg"
NPIPERELAY="/mnt/c/Users/${USERNAME}/bin/npiperelay.exe"
PIDFILE="${GPGDIR}/.gpg-agent-relay.pid"
OLDPID=$(cat "${PIDFILE}")

echo OLDPID:$OLDPID >> $LOGFILE

# Launch socat+npiperelay for the regular gpg-agent
if [ ! -z "${OLDPID}" ]; then
	echo OLDPID:$OLDPID is not empty >> $LOGFILE
	ps -p "${OLDPID}" >/dev/null
	if [ $? -eq 0 ]; then
		echo "gpg-agent-relay.sh already running with process id $(cat ${PIDFILE}), exiting!!" >> $LOGFILE
		exit 0
	else
		echo "gpg-agent-relay.sh is NOT running, start it!" >> $LOGFILE
	fi
fi

echo Before remove >> $LOGFILE
ls -al "${GPGDIR}" >> $LOGFILE
rm "${GPGDIR}/S.gpg-agent*" >> $LOGFILE
echo Done remove >> $LOGFILE
ls -al "${GPGDIR}" >> $LOGFILE
echo after remove >> $LOGFILE

echo $$ > ${PIDFILE}
echo New pidfile is $(cat $PIDFILE) >> $LOGFILE

# Relay the regular gpg-agent socket for gpg operations
socat UNIX-LISTEN:"${GPGDIR}/S.gpg-agent,fork" EXEC:"${NPIPERELAY} -ep -ei -s -a '${WIN_GPGDIR}/S.gpg-agent'",nofork &
AGENTPID=$!

# Relay the gpg ssh-agent
socat UNIX-LISTEN:"${GPGDIR}/S.gpg-agent.ssh,fork" EXEC:"${NPIPERELAY} -ep -ei -s -a '${WIN_GPGDIR}/S.gpg-agent.ssh'",nofork &
SSHPID=$!

ls -al "${GPGDIR}"
echo after connecting to gpg-agents >> $LOGFILE

echo Waiting AGENTPID:$AGENTPID >> $LOGFILE
wait ${AGENTPID}
echo Waiting SSHPID:$SSHPID >> $LOGFILE
wait ${SSHPID}
