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
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "SCRIPT_RUN=${SCRIPT_RUN}"
echo "SCRIPT_DIR=${SCRIPT_DIR}"

. ${SCRIPT_RUN}/shell_common.sh

# Environment variables
: ${NTNX_PKG_JQ_VER:="latest"}

# Check tools
if ! type jq > /dev/null 2>&1; then
    _base_url="https://github.com/jqlang/jq/releases"
    _filename="jq-linux-amd64"

    if [ "$NTNX_PKG_JQ_VER" = "latest" ]; then
        _package_url="${_base_url}/latest/download/${_filename}"
    else
        _package_url="${_base_url}/download/${NTNX_PKG_JQ_VER}/${_filename}"
    fi
    # execute_command curl -sSL -o jq-linux-amd64 "https://github.com/jqlang/jq/releases/download/${NTNX_PKG_JQ_VER}/jq-linux-amd64"
    execute_command wget ${_package_url}
    execute_command chmod +x ${_filename}
    execute_command sudo mv -f ${_filename} /usr/local/bin/jq
    execute_command jq --version

    unset _base_url _filename _package_url
fi
