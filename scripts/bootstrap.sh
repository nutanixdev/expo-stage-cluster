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

: ${NTNX_GH_ORGANIZATION:="nutanixdev"}
: ${NTNX_GH_REPOSITORY:="expo-stage-cluster"}
: ${NTNX_GH_BRANCH:="main"}

BASE_URL=https://github.com/${NTNX_GH_ORGANIZATION}/${NTNX_GH_REPOSITORY}
ARCHIVE=${BASE_URL}/archive/${NTNX_GH_BRANCH}.zip

case "${1}" in
  clean )
    echo "Cleaning up..."
    #rm -rf ${ARCHIVE##*/} ${0} ${REPOSITORY}-${BRANCH}/
    exit 0
    ;;
  cache )
    cache
    ;;
  *)
    WORKSHOP="${1}"
    ;;
esac

if [[ -f ${NTNX_GH_BRANCH}.zip ]]; then
    echo "here"
    sh ${HOME}/${0} clean
fi

echo -e "\nFor details, please see: ${BASE_URL}/docs/guidebook.md"

_ERROR=0
