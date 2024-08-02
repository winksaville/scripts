#!/usr/bin/env bash
# Initialize my working environment

# Enable error options
#  -E -> inherits ERR trap
#  -u -> treat unset variables as an error
#  -o pipefail -> return code of the first failed command in a pipeline
#
# Previously I used -e but this caluses nvoked commands that return with
# non-zero exit codes fail immediately and silently.
# I.e. `systemctl is-active xxx``
set -Euo pipefail

# Enable debug
#set -x

# Initialize bash and basic stuff
source init-bash.sh

# Initialize terminator layouts
mkdir -p ~/.config/terminator
cp ~/scripts/config-terminator-config ~/.config/terminator/config

# Initialize ssh config
mkdir -p ~/.ssh
cp ~/scripts/ssh/* ~/.ssh/
chmod 600 ~/.ssh/config

# Initialize gitconfig
cp ~/scripts/gitconfig ~/.gitconfig

# Remind user, wink, to get the git-commits-* files for
# signing commits. These must match what's in scripts/gitconfig
files=(~/.ssh/git-commits-*)
if [[ ${#files[@]} == 0 ]]; then
	echo "Copy git-commits-* to ~/.ssh/ such as 'scp wink@3900x:~/.ssh/git-commits-* ~/.ssh/'"
	echo "and update private key permissions 'chmod 600 ~/.ssh/git-commits-wink@saville.com'"
#else
#	echo "Testing git-commits exist: ${files[@]}"
fi

mkdir -p ~/bin
cp ~/scripts/update-lighthouse.sh ~/bin/
cp ~/scripts/remove-all-from-docker.sh ~/bin/
cp ~/scripts/screensaver-lock-display-off ~/bin/
cp ~/scripts/mbvc.sh ~/bin/
cp ~/scripts/missing-failed-success-ratio.sh ~/bin/
cp ~/scripts/print-info.sh ~/bin/
cp ~/scripts/backup-file.sh ~/bin/
cp ~/scripts/vm-move.sh ~/bin/
cp ~/scripts/temp-info.sh ~/bin/
cp ~/scripts/copy-from-remote.sh ~/bin/

# Update config files for timeserver and dnsserver

time_server="rpi38"
dns_server="rpi23"

backup_copy_if_different() {
	local src=$1
	local dst=$2
	#echo src=$src dst=$dst
	if ! cmp -s "$src" "$dst"; then
		echo "DIFFERENT; Backing up and copying $src to $dst"
		sudo backup-file.sh $dst
		sudo cp $src $dst
	else
		if ! compgen -G "$dst*.backup" >/dev/null; then
			read -p "No backup file, $dst*.backup, create one (Y/n): " answer
			answer=${answer:-y}
			answer=${answer,,}
			if [[ "$answer" == "y" ]]; then
				echo "backing up $dst"
				sudo backup-file.sh $dst
			else
				echo "skipped $dst"
			fi
		else
			echo "SAME; $src $dst do NOTHING"
		fi
	fi
}

# Update chrony.conf which can be in two different places:
# On Arch Linux /etc/chrony.conf
# On Ubuntu /etc/chrony/chrony.conf

if [[ -f /etc/chrony.conf ]]; then
	chrony_path="/etc/chrony.conf"
elif [[ -f /etc/chrony/chrony.conf ]]; then
	chrony_path="/etc/chrony/chrony.conf"
else
	echo "FATAL: chrony is not installed"
	exit 1
fi

if [[ "$HOSTNAME" == "$time_server" ]]; then
	backup_copy_if_different ~/scripts/chrony.conf.use-on-time_server $chrony_path
else
	backup_copy_if_different ~/scripts/chrony.conf.use-on-other $chrony_path
fi


#The two resolv.conf.use-on-* are only applicable to the ATT network,
#I need to work out a better technique. The main thing I want to do is
#that the local computer needs to be able to resolve device names on
#the local lan.
#
#Maybe all I need is `search lan`?

## Update /etc/resolv.conf
#if [[ -f /etc/resolv.conf ]]; then
#	dst="/etc/resolv.conf"
#else
#	echo "FATAL: Weird, there is no resolv.conf"
#	exit 1
#fi
#if [[ "$HOSTNAME" == "$dns_server" ]]; then
#	backup_copy_if_different ~/scripts/resolv.conf.use-on-dns_server $dst
#else
#	backup_copy_if_different ~/scripts/resolv.conf.use-on-other $dst
#fi

# Update dnsmasq.conf on dns_server only
dst=/etc/dnsmasq.conf
if [[ "$HOSTNAME" == "$dns_server" ]]; then
	if [[ -f $dst ]]; then
		backup_copy_if_different ~/scripts/dnsmasq.conf.use-on-dns_server /etc/dnsmasq.conf
	else
		echo "FATAL: designated as dns_server but no $dst"
		exit 1
	fi
elif [[ -f $dst ]]; then
	echo "UNEXPECTED: Has dnsmasq.conf but this isn't designated as dns_server!"
fi

service-is-active() {
	systemctl is-active --quiet "$1"
	#local r=$?
	#echo "service-is-active $1: $r"
	#return $r
	return $? # comment this line and uncomment the next lines for debug
}

# Update vnstat.service
service=vnstat.service
dst_file=/etc/vnstat.conf
src_file=~/scripts/vnstat.conf

if [[ -f $dst_file ]] && service-is-active $service; then
	#echo "EXPECTED: $dst_file exists and $service is active"
	backup_copy_if_different $src_file $dst_file
else
	echo "UNEXPECTED: $dst_file does not exist or $service is not active or not installed"
	exit 1
fi

exit 0


