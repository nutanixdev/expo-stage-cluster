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

# Environment variables
: ${NTNX_GH_ORGANIZATION:="nutanixdev"}
: ${NTNX_GH_REPOSITORY:="expo-stage-cluster"}
: ${NTNX_GH_BRANCH:="main"}
: ${NTNX_PRISM_NW1_NAME:="primary"}
: ${NTNX_PRISM_NW2_NAME:="secondary"}
: ${NTNX_PRISM_DNS_SERVERS:="10.42.194.10,10.42.196.10,10.54.1.5"}
: ${NTNX_PRISM_NTP_SERVERS:="time1.google.com,time2.google.com,time3.google.com"}

BASE_URL=https://github.com/${NTNX_GH_ORGANIZATION}/${NTNX_GH_REPOSITORY}
ARCHIVE_URL=${BASE_URL}/archive/${NTNX_GH_BRANCH}.zip
ARCHIVE_FILENAME=${NTNX_GH_REPOSITORY}-${NTNX_GH_BRANCH}


CURL_OPTS="--insecure --silent --show-error --location"

. /etc/profile

echo -e "\nFor details, please see: ${BASE_URL}/docs/guidebook.md"

if [[ -f ${ARCHIVE_FILENAME}.zip || -d ${ARCHIVE_FILENAME} ]]; then
  /bin/rm -fR "${ARCHIVE_FILENAME}"*
fi

curl ${CURL_OPTS} --output "${ARCHIVE_FILENAME}.zip" "$ARCHIVE_URL"

unzip "${ARCHIVE_FILENAME}"
