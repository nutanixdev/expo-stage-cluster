#!/usr/bin/env bash

# Copyright Nutanix Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# How to run: 
#   Standard: bash <(curl -s http://127.0.0.1:5500/menu.sh) arg1 arg2 arg3 ...
#   Test: NTNX_SCRIPT_USER=$USER bash <(curl -s http://127.0.0.1:5500/menu.sh) arg1 arg2 arg3 ...

# Environment variables
: ${NTNX_SCRIPT_USER:="nutanix"}
: ${NTNX_GH_ORGANIZATION:="nutanixdev"}
: ${NTNX_GH_REPOSITORY:="expo-stage-cluster"}
: ${NTNX_GH_BRANCH:="main"}
: ${NTNX_PRISM_NTP_SERVERS:="time1.google.com,time2.google.com,time3.google.com"}
: ${NTNX_PRISM_DNS_SERVERS:="10.42.194.10"}

# GitHub
NTNX_GH_REPOSITORY_URL="https://github.com/${NTNX_GH_ORGANIZATION}/${NTNX_GH_REPOSITORY}"
NTNX_GH_ARCHIVE_FILENAME="${NTNX_GH_BRANCH}.zip"
NTNX_GH_ARCHIVE_URL="${NTNX_GH_REPOSITORY_URL}/archive/${NTNX_GH_ARCHIVE_FILENAME}"
NTNX_GH_ARCHIVE_DIR="${NTNX_GH_REPOSITORY}-${NTNX_GH_BRANCH}"

# Curl, Wget, and SSH settings
CURL_OPTS='--insecure --silent --show-error --location' # --verbose'
CURL_POST_OPTS="${CURL_OPTS} --max-time 15 --header Content-Type:application/json --header Accept:application/json" # --output /dev/null"
CURL_HTTP_OPTS="${CURL_POST_OPTS} --write-out %{http_code}"
SSH_OPTS='-i ~/.ssh/tme_id_rsa -o StrictHostKeyChecking=no -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null'
SSH_OPTS+=' -q' # -v'
WGET_OPTS='--no-check-certificate --quiet --progress=bar:force --timestamping'

# check the logged in user is nutanix 
function user_is_nutanix() {
    if [ "$USER" != "$NTNX_SCRIPT_USER" ]; then
        echo "You must run this script as '${NTNX_SCRIPT_USER}' user"
        exit 1
    fi 
}

# check if acli exists
function check_acli_exists() {
    if ! type acli > /dev/null 2>&1; then
        echo "You must run this script from a Nutanix CVM"
        exit 1
    fi
}

# Function to display the menu
function display_menu() {
    echo "Menu Options:"
    echo "1. Stable"
    echo "2. Experimental"
    echo "3. Remote"
    echo "0. Quit"
}

# Function to process the user's choice
function process_choice() {
    case "$1" in
        0)
            exit 0
            ;;
        1)
            echo "You chose Stable"
            check_acli_exists
            ;;
        2)
            echo "You chose Experimental"
            check_acli_exists
            ;;
        3)
            echo "You chose Remote"
            ;;
        *)
            echo "Invalid option"
            main
            ;;
    esac
}

function main() {
    # Execution
    user_is_nutanix

    # Check if arguments are provided
    if [ $# -gt 0 ]; then
        process_choice "$1"
    else
        # If no arguments, check for environment variables
        if [ -n "$MENU_OPTION" ]; then
            process_choice "$MENU_OPTION"
        else
            # If no environment variable, display the menu and prompt for input
            display_menu
            read -p "Enter your choice: " choice
            process_choice "$choice"
        fi
    fi

    # source <(curl -s http://127.0.0.1:5500/scripts/base.sh)

    # Call the function with the command passed to the script
    # echo_command "$@"

    local temp_dir=$(mktemp -d "$HOME/tme-$NTNX_GH_ARCHIVE_DIR-XXXXXX")
    cd "$temp_dir"
    wget $WGET_OPTS "$NTNX_GH_ARCHIVE_URL"
    unzip -q "$NTNX_GH_ARCHIVE_FILENAME" && /bin/rm "$NTNX_GH_ARCHIVE_FILENAME"
    mv "$NTNX_GH_ARCHIVE_DIR"/* . && /bin/rm -fr "$NTNX_GH_ARCHIVE_DIR"

}

main
. scripts/prereqs.sh
. scripts/base.sh
