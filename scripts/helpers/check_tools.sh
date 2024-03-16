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

. shell_common.sh

# Environment variables
: ${NTNX_PKG_JQ_VER:="latest"}

# Check tools
HAS_CURL="$(type "curl" &> /dev/null && echo true || echo false)"
HAS_WGET="$(type "wget" &> /dev/null && echo true || echo false)"
HAS_OPENSSL="$(type "openssl" &> /dev/null && echo true || echo false)"
HAS_GPG="$(type "gpg" &> /dev/null && echo true || echo false)"
HAS_GIT="$(type "git" &> /dev/null && echo true || echo false)"

# Figure out correct version of a three part version number is not passed
find_version_from_git_tags() {
}

if ! type jq > /dev/null 2>&1; then
    execute_command find_version_from_git_tags NTNX_PKG_JQ_VER 'https://github.com/jqlang/jq'
    execute_command curl -sSL -o jq-linux-amd64 "https://github.com/jqlang/jq/releases/download/${NTNX_PKG_JQ_VER}/jq-linux-amd64"
    execute_command chmod +x jq-linux-amd64
    execute_command sudo mv -f jq-linux-amd64 /usr/local/bin/jq
    execute_command jq --version
fi