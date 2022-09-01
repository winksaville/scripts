#!/bin/bash
#
# capture.sh
#

ssh_jctl() {
	local acct_name=$1
	local srvc=$2
	local since_param=$3
	local rg_param=$4
	#eval "ssh $acct_name journalctl -u $srvc.service --since $since_param | rg \"Starting|ERRO\""
	eval "ssh $acct_name journalctl -u $srvc.service --since $since_param | rg --color always $rg_param"
}

acct_name=kendall@hazel
srvc=beacon-chain
since_param=-30h
rg_param="\"Starting|ERRO\""

#echo "call ssh_jctl"
ssh_jctl "$acct_name" "$srvc" "$since_param" "$rg_param"
#echo "retf ssh_jctl"

#cmdline=ssh_jctl
#cmdline=./ssh-jctl.sh
#cmdline=$(ssh kendall@hazel journalctl -u beacon-chain.service --since -1d | rg "Starting|ERRO")
{
    IFS=$'\n' read -r -d '' CAPTURED_STDERR;
    IFS=$'\n' read -r -d '' CAPTURED_STDOUT;
} < <((printf '\0%s\0' "$(ssh_jctl "$acct_name" "$srvc" "$since_param" "$rg_param")" 1>&2) 2>&1)

error_code=$?

hexdmp() {
	#printf "IFS='0x%2x' " "'$IFS"
	OLD_IFS=$IFS
	#unset IFS
	printf "IFS='0x%02x'\n" "'$IFS"
	while read -r -n 1 char; do
		printf "0x%02X " "'$char";
	done < <(printf "$1")
	printf "\n"
	IFS=$OLD_IFS
	printf "IFS='0x%02x'\n" "'$IFS"
}

hexdmp "Starting"
hexdmp "${CAPTURED_STDOUT}"

echo 'Here is the captured stdout:'
echo "${CAPTURED_STDOUT}"
echo

echo 'And here is the captured stderr:'
echo "${CAPTURED_STDERR}"
echo

echo "error_code: $error_code"
