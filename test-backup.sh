#!/usr/bin/env bash

# Enable error options
set -Eeuo pipefail

# Enable debug
#set -x

time_server="joe"
dns_server="fred"

backup_copy_if_different() {
	local src=$1
	local dst=$2
	#echo src=$src dst=$dst
	if ! cmp -s "$src" "$dst"; then
		#echo "DIFFERENT; Backing up and copying $src to $dst"
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


# Update /etc/resolv.conf
if [[ -f /etc/resolv.conf ]]; then
	dst="/etc/resolv.conf"
else
	echo "FATAL: Weird, there is no resolv.conf"
	exit 1
fi
if [[ "$HOSTNAME" == "$dns_server" ]]; then
	backup_copy_if_different ~/scripts/resolv.conf.use-on-dns_server $dst
else
	backup_copy_if_different ~/scripts/resolv.conf.use-on-other $dst
fi

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

