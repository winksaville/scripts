#!/usr/bin/env bash
# or /bin/sh for a "portable" shebang
#
# This is used to set the static address and gateway of a linux computer.
# Initial use is to connect to linux computer to a OpenWRT router that's
# in "failsafe mode" (https://openwrt.org/docs/guide-user/troubleshooting/failsafe_and_factory_reset)
# and that's why addr_gateway_default is 192.168.1.1.
#
# Note:
#   On my TpLink Archer A7 1750 the "button" referred to in the above page
#   is the 'WPS/WiFi On/Off' switch.
#
# Parameter handling from named-parameter-example-script.sh

# Enable error options
set -Eu
set -eo pipefail

# Enable debug
#set -x

# Default values
addr_default=192.168.1.2
class_default=24
addr_gateway_default=192.168.1.1

# Initialize variables, dev is required
dev=
addr=$addr_default
addr_gateway=$addr_gateway_default
class=$class_default

usage() {
  echo "Usage: $0 [OPTIONS]"
  echo
  echo "Note: You may have to stop NetworkManager using:"
  echo "  sudo systemctl stop NetworkManager.service"
  echo "Later start it:"
  echo "  sudo systemctl start NetworkManager.service"
  echo "Or reboot"
  echo
  echo "Options:"
  echo "  dev=<dev name>            Name of device such as 'enp0s13f0u3', REQUIRED"
  echo "  addr=<IPv4 addr>          IPv4 address, default $addr_default"
  echo "  class=<IPv4 class>        Class such as 24, default $class_default"
  echo "  addr_gateway=<IPv4 addr>  IPv4 address of gateway, default $addr_gateway_default"
  echo "  help                      Show this help message"
  echo
  echo "Example:"
  echo "  $0 addr=192.168.1.3 dev=eth0"
}

parse_arguments() {
  if [ "$#" -eq 0 ]; then
    usage
    exit 0
  fi

  for arg in "$@"; do
    # Split argument into key and value
    key="${arg%%=*}"
    value="${arg#*=}"

    # Check if the key and value are the same, indicating that the '=' sign was missing
    if [[ "$key" == "$value" ]]; then
      echo "Invalid argument '$key' expecting '$key=...'"
      usage
      exit 1
    fi

    # Remove quotes if value is wrapped with them
    value="${value%\"}"
    value="${value#\"}"

    # Process the arguments
    case "$key" in
      dev)
        dev="$value"
        ;;
      addr)
        addr="$value"
        ;;
      class)
        class="$value"
        ;;
      addr_gateway)
        addr_gateway="$value"
        ;;
      help)
        usage
        exit 0
        ;;
      *)
        echo "Unknown parameter: $key"
        usage
        exit 1
        ;;
    esac
  done
}

validate_variables() {
  err=false
  if [[ -z $dev ]]; then
    echo "dev is empty, it is required something like enp0s13f0u3"
    err=true
  fi
  if [[ -z $addr ]]; then
    echo "addr is empty, if not passed defaults to $addr_default"
    err=true
  fi
  if [[ -z $class ]]; then
    echo "class is empty, if not passed defaults to $class_default"
    err=true
  fi
  if [[ $err == true ]]; then
    exit 1
  fi
}

set_interface_state() {
    local interface=$1
    local desired_status=$2
    local max_wait_time_ms=$3

    local start_time=$(date +%s%3N)

    # Check the current state of the interface
    current_state=$(cat /sys/class/net/$interface/operstate 2>/dev/null)

    if [[ $current_state == $desired_status ]]; then
        #echo "$interface is already in the desired state: $desired_status"
        return 0
    fi

    # Set the desired state for the interface (requires sudo)
    #echo "Setting $interface to $desired_status..."
    sudo ip link set $interface $desired_status

    echo "Waiting for $interface to be $desired_status"
    while true; do
        state=$(cat /sys/class/net/$interface/operstate 2>/dev/null)

        if [[ $state == $desired_status ]]; then
            echo "$interface is now $desired_status"
            return 0
        fi

        current_time=$(date +%s%3N)
        elapsed_time=$((current_time - start_time))

        if (( elapsed_time >= max_wait_time_ms )); then
            echo "Timeout reached. $interface did not become $desired_status within $max_wait_time_ms milliseconds."
            return 1
        fi

	#ip a show $interface
        sleep 1  # Sleep for 1 second
    done
}

# Parse the arguments
parse_arguments "$@"

# Validate the variabes are valid
validate_variables

# Output the parameters
#echo "dev: $dev"
#echo "addr: $addr"
#echo "class: $class"

# Add the address and default route

# Down the device
#sudo ip link set $dev down
set_interface_state $dev down 2000 || { echo "Could not down $dev"; exit 1; }
#ip a show $dev

# remove address in case it exists
set +e +o pipefail # ignore errors
sudo ip addr del $addr/$class dev $dev
set -e -o pipefail # reenable errors
#ip a show $dev

# Add address
echo add $addr/$class
sudo ip addr add $addr/$class dev $dev

# Up the dev ice
#sudo ip link set $dev up
set_interface_state $dev up 4000 || { echo "Could not UP $dev"; exit 1; }
#ip a show $dev

#sleep 1
#ip a show $dev

# Set default route
echo add default route via $addr_gateway dev $dev
sudo ip route add default via $addr_gateway dev $dev
##ip a show $dev
##ip r

