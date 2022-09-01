#!/usr/bin/env bash

# Enable error options
set -Ee
set -uo pipefail

# Enable debug
#set -x

app_name=$(basename $0)
if (( $# < 2 )); then
	echo "Usage: $app_name account@machine search since services"
	echo "  Search logs of service from account on machine since-some-time"
	echo
	echo "Example:"
	echo "  $app_name kendall@hazel \"Starting|ERRO\"" -1h validator
	echo
	echo "Required Params:"
	echo "  account@machine:  kendall@hazel"
	echo '  serach:           "Starting|ERRO"'
	echo
	echo "Option Params:"
	echo "  since:           exmaple -1h, default: -1d"
	echo "  services:        example validator, default: eth1 beacon-chain validator"

	exit 1
fi

# # Answer 7 fromh ttps://stackoverflow.com/a/59592881
# #
# # Called like so:
# #    catch STDOUT_VARIABLE STDERR_VARIABLE COMMAND [ARG1[ ARG2[ ...[ ARGN]]]]
# catch() {
#     {
#         IFS=$'\n' read -r -d '' "${1}";
#         IFS=$'\n' read -r -d '' "${2}";
#         (IFS=$'\n' read -r -d '' _ERRNO_; return ${_ERRNO_});
#     } < <((printf '\0%s\0%d\0' "$(((({ shift 2; ${@}; echo "${?}" 1>&3-; } | tr -d '\0' 1>&4-) 4>&2- 2>&1- | tr -d '\0' 1>&4-) 3>&1- | exit "$(cat)") 4>&1-)" "${?}" 1>&2) 2>&1)
# }

ssh_jctl() {
	local acct_machine=$1
	local srvc=$2
	local since_param=$3
	local rg_param=$4
	eval "ssh $acct_machine journalctl -u $srvc.service --since $since_param | rg --color always $rg_param"
}


acct_machine=$1
shift
rg_param=$1
shift
since_param=${1:- -1d}
shift
services=${@:- eth1 beacon-chain validator}
echo acct_machine: $acct_machine, rg_param: "$rg_param", since_param: "$since_param", services: "$services"
#ssh $acct_machine "journalctl -u eth1.service --since $since_param | rg \"$rg_param\"; journalctl -u beacon-chain.service --since $since_param | rg \"$rg_param\"; journalctl -u validator.service --since $since_param | rg \"$rg_param;\""
for srvc in $services; do
	#attempt 4
	echo "Processing $srvc.service"
	{
	    echo 1
	    IFS=$'\n' read -r -d '' SE_data;
	    echo 2
	    IFS=$'\n' read -r -d '' SO_data;
	    echo 3
	    #(IFS=$'\n' read -r -d '' error_code;)
	    echo 4
	} < <((printf '\0%s\0' "$(ssh_jctl "$acct_machine" "$srvc" "$since_param" "$rg_param")" 1>&2) 2>&1)
	echo "error_code: $error_code"
	#error_code=$?

	##attempt 3
	#set +Ee
	#unset SO_data SE_data error_code

	##cmdline="ssh $acct_machine \"journalctl -u $srvc.service --since $since_param | rg \"$rg_param\"\""
	##echo "cmdline: $cmdline"
	#eval "$("ssh $acct_machine \"journalctl -u $srvc.service --since $since_param | rg \"$rg_param\"\"" \
	#	2> >(SE_data=$(cat); typeset -p SE_data) \
	#	 > >(SO_data=$(cat); typeset -p SO_data); error_code=$?; typeset -p error_code )"
	#set -Ee

	##attempt 2
	#set +Ee
	#catch SO_data SE_data ssh $acct_machine "journalctl -u $srvc.service --since $since_param | rg \"$rg_param\""
	#set -Ee
	#error_code=$?
	#echo "error_code: $error_code"

	case $error_code in
		0)
			echo OK SO_data len=${#SO_data}
			echo OK SE_data len=${#SE_data}
			#echo "SO_data:\n$SO_data"
			#echo "SE_data:\n$SE_data"
			echo "$SO_data"
			;;
		1)
			echo "error_code: $error_code"
			echo "SO_data: len=${#string}\n$SO_data"
			echo "SE_data: len=${#string}\n$SE_data"
			exit $error_code
			;;
		*)
			echo "error_code: $error_code is not 1"
			echo "SO_data: len=${#string}\n$SO_data"
			echo "SE_data: len=${#string}\n$SE_data"
			exit $error_code
			;;
	esac

	#attempt 1
	#set +Ee
	#ssh $acct_machine "journalctl -u $srvc.service --since $since_param | rg \"$rg_param\""
	#set -Ee
	#if [[ "$error_code" != "0" ]]; then
	#	echo "ERROR: bad parameter executing -> ssh $acct_machine journalctl -u $srvc.service --since $since_param | rg \"$rg_param\""
	#	exit 1
	#fi
done

