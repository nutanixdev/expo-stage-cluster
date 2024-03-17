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

SCRIPT_RUN="$(dirname "${BASH_SOURCE[0]}")"

. ${SCRIPT_RUN}/shell_common.sh
. /etc/profile

function prism_configure_ntp() {
    local _existing_ntp_servers=$(ncli cluster get-ntp-servers | grep -oP 'NTP Servers\s*:\s*\K(.*$)' | sed 's/ //g')

    if [ "$_existing_ntp_servers" == "${NTP_SERVERS}" ]; then
        execute_command echo "IDEMPOTENCY: ${NTP_SERVERS} NTP server(s) set, skip."
    else
        if [ -n "${_existing_ntp_servers}" ]; then
            execute_command echo "Remove existing NTP server(s)"
            execute_command ncli cluster remove-from-ntp-servers ntp-servers=$_existing_ntp_servers
        fi
        execute_command echo "Configure NTP server(s)"
        execute_command ncli cluster add-to-ntp-servers ntp-servers=${NTP_SERVERS}
    fi
}