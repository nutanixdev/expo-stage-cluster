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

# SCRIPT_RUN="$(dirname "${BASH_SOURCE[0]}")"

# . ${SCRIPT_RUN}/shell_common.sh
# . /etc/profile

function prism_configure_ntp() {
    local _existing_ntp_servers=$(ncli cluster get-ntp-servers | grep -oP 'NTP Servers\s*:\s*\K(.*$)' | sed 's/ //g')

    if [ "$_existing_ntp_servers" == "${NTNX_PRISM_NTP_SERVERS}" ]; then
        execute_command echo "IDEMPOTENCY: ${NTNX_PRISM_NTP_SERVERS} NTP server(s) set, skip."
    else
        if [ -n "${_existing_ntp_servers}" ]; then
            execute_command echo "Remove existing NTP server(s)"
            execute_command ncli cluster remove-from-ntp-servers ntp-servers=$_existing_ntp_servers
        fi
        execute_command echo "Configure NTP server(s)"
        execute_command ncli cluster add-to-ntp-servers ntp-servers=${NTNX_PRISM_NTP_SERVERS}
    fi
}

function prism_configure_dns() {
    local _existing_dns_servers=$(ncli cluster get-name-servers | grep -oP 'Name Servers\s*:\s*\K(.*$)' | sed 's/ //g')

    if [ "$_existing_dns_servers" == "${NTNX_PRISM_DNS_SERVERS}" ]; then
        execute_command echo "IDEMPOTENCY: ${NTNX_PRISM_DNS_SERVERS} DNS server(s) set, skip."
    else
        if [ -n "${_existing_dns_servers}" ]; then
            execute_command echo "Remove existing DNS server(s)"
            execute_command ncli cluster remove-from-name-servers name-servers=$_existing_dns_servers
        fi
        execute_command echo "Configure DNS server(s)"
        execute_command ncli cluster add-to-name-servers name-servers=${NTNX_PRISM_DNS_SERVERS}
    fi
}

function prism_accept_eula() {
    local _host="${1:-"localhost"}"

    execute_command echo "accepting eula"

    execute_command curl ${CURL_HTTP_OPTS} -X POST \
        --user ${NTNX_PRISM_USERNAME}:${NTNX_PRISM_PASSWORD} \
        --data '{"username":"TME","companyName":"Nutanix","jobTitle":"TME"}' \
        https://$_host:9440/PrismGateway/services/rest/v1/eulas/accept 
}

function prism_disable_pulse() {
    local _host="${1:-"localhost"}"

    execute_command echo "disabling pulse"

    execute_command curl ${CURL_HTTP_OPTS} -X PUT \
        --user ${NTNX_PRISM_USERNAME}:${NTNX_PRISM_PASSWORD} \
        --data '{"emailContactList":null,"enable":false,"verbosityType":null,"enableDefaultNutanixEmail":false,"defaultNutanixEmail":null,"nosVersion":null,"isPulsePromptNeeded":false,"remindLater":null}' \
        https://$_host:9440/PrismGateway/services/rest/v1/pulse 
}

function prism_ui_timeout() {
    local _host="${1:-"localhost"}"
    local _json
    local _http_body
    local _test

    _json=$(cat <<EOF
    {"type":"UI_CONFIG","username":"system_data","key":"disable_2048","value":true} \
    {"type":"UI_CONFIG","key":"autoLogoutGlobal","value":"7200000"} \
    {"type":"UI_CONFIG","key":"autoLogoutOverride","value":"0"}
EOF
    )

    execute_command echo "increasing Prism UI timeout"

    for _http_body in ${_json}; do
        execute_command curl ${CURL_HTTP_OPTS} \
            --user ${NTNX_PRISM_USERNAME}:${NTNX_PRISM_PASSWORD} -X PUT --data "${_http_body}" \
            https://$_host:9440/PrismGateway/services/rest/v1/application/system_data
    done

    _http_body='{"username": "admin","type":"UI_CONFIG","key":"autoLogoutTime","value": "0"}'
    execute_command curl ${CURL_HTTP_OPTS} \
        --user ${NTNX_PRISM_USERNAME}:${NTNX_PRISM_PASSWORD} -X PUT --data "${_http_body}" \
        https://$_host:9440/PrismGateway/services/rest/v1/application/user_data
}