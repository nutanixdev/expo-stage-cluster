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

####################################################
# fail_trap is executed if an error occurs.
####################################################
fail_trap() {
  result=$?
  if [ "$result" != "0" ]; then
    if [[ -n "$INPUT_ARGUMENTS" ]]; then
      echo "Failed to install with the arguments provided: $INPUT_ARGUMENTS"
      help
    else
      echo "Failed to install"
    fi
    echo -e "\tFor support, go to #technology-bootcamp."
  fi
  cleanup
  exit $result
}

####################################################
# cleanup temporary files
####################################################
cleanup() {
  if [[ -d "${PACKAGE_TMP_ROOT:-}" ]]; then
    /bin/rm -rf "$PACKAGE_TMP_ROOT"
  fi
}

####################################################
# log executed commands
####################################################
log_info() {
    echo "[INFO] $(date +'%Y-%m-%d %H:%M:%S') $$ - $@"
}

log_warn() {
    echo "[WARN] $(date +'%Y-%m-%d %H:%M:%S') $$ - $@" >&2
}

log_error() {
    echo "[ERROR] $(date +'%Y-%m-%d %H:%M:%S') $$ - $@" >&2
}

execute_command() {
    # Log the command being executed
    log_info "Executing command: $@"

    # Execute the command
    "$@"

    # Check the exit status of the command
    if [ $? -eq 0 ]; then
        log_info "Command executed successfully"
    else
        log_error "Command failed with exit code $?"
    fi
}

####################################################
# download files
####################################################
function download() {
    local url=$1
    local filename=$(basename "$url")

    curl ${CURL_OPTS} --output "$filename" "$url"
    echo "$filename"
}