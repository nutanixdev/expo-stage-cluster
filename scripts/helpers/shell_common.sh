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