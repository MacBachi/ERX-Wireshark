#!/bin/bash

# Improved Remote Packet Capture Script
# This script is a modified version based on the work of Jerico Thomas
# Modifications made by: Markus Bachlechner
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License Version 3 as published by
# the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.

# Set strict mode for better error handling and debugging
set -euo pipefail

# Usage instructions
usage() {
    cat << EOF
Usage: $0 -u <USER> -s <SERVER> -p <PORT> -i <INTERFACE> [-f <FILTER>]
    -u USER        : SSH username
    -s SERVER      : SSH server IP or hostname
    -p PORT        : SSH port (default: 22)
    -i INTERFACE   : Network interface to monitor
    -f FILTER      : Optional tcpdump filter (e.g., 'port 80')
    -h             : Display this help message
EOF
    exit 2
}

# Log functions for better output control
log_info() {
    echo "[INFO] $1"
}

log_error() {
    echo "[ERROR] $1" >&2
}

# Check dependencies
check_dependencies() {
    local dependencies=(ssh wireshark)
    for cmd in "${dependencies[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            log_error "$cmd is required but not installed."
            exit 1
        fi
    done
}

# Validate parameters
validate_parameters() {
    if [[ -z "$USER" ]]; then
        log_error "Username (-u) is required."
        usage
    fi
    if [[ -z "$SERVER" ]]; then
        log_error "Server (-s) is required."
        usage
    fi
    if ! [[ "$PORT" =~ ^[0-9]+$ ]]; then
        log_error "Port (-p) must be a valid number."
        usage
    fi
    if [[ -z "$INTERFACE" ]]; then
        log_error "Network interface (-i) is required."
        usage
    fi
}

# Start Wireshark
start_wireshark() {
    local cmd="ssh -p $PORT $USER@$SERVER /usr/sbin/tcpdump -i $INTERFACE $FILTER -U -w -"
    log_info "Starting Wireshark..."
    if [ -n "$FILTER" ]; then
        log_info "Applying filter: $FILTER"
    fi
    wireshark -k -i <($cmd) || {
        log_error "Failed to start Wireshark or SSH connection."
        exit 1
    }
}

# Initialize variables with defaults
USER=""
SERVER=""
PORT="22"
INTERFACE=""
FILTER=""

# Get parameters
while getopts "u:s:p:i:f:h" opt; do
    case "$opt" in
        u) USER="$OPTARG" ;;
        s) SERVER="$OPTARG" ;;
        p) PORT="$OPTARG" ;;
        i) INTERFACE="$OPTARG" ;;
        f) FILTER="$OPTARG" ;;
        h) usage ;;
        *) usage ;;
    esac
done

# Check dependencies before running
check_dependencies

# Validate required parameters
validate_parameters

# Trap to handle script interruptions (Ctrl+C)
trap "log_info 'Script terminated'; exit 130" INT TERM

# Start Wireshark
start_wireshark

# Exit successfully
exit 0
