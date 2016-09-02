#!/bin/bash
#
#  Copyright 2016 Johns Hopkins University
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

# Required environment variables for interpolation to succeed
if [ -z ${DOCKER_OSF_HOST} ]  ;
then
  echo "Missing required environment variable 'DOCKER_OSF_HOST'"
  echo "Either re-execute the 'docker run' with '-e DOCKER_OSF_HOST=192.168.99.100'"
  echo "    $ docker run -e DOCKER_OSF_HOST=192.168.99.100 ..."
  echo "or if using 'docker-compose' make sure the variable is present in the .env file."
  exit 1
fi

# Produce Waterbutler runtime configuration by interpolating the template
# configuration file with runtime environment variables
TEMPLATE_FILE=${CONFIG_DIR}/waterbutler-test.json.tmpl
CONFIG_FILE=${CONFIG_DIR}/waterbutler-test.json

echo "Interpolating ${TEMPLATE_FILE} to ${CONFIG_FILE}"
cat ${TEMPLATE_FILE} | envsubst > ${CONFIG_FILE}
echo "Copying ${CONFIG_FILE} to ${HOME}/.cos"
mkdir -p $HOME/.cos
cp ${CONFIG_FILE} ${HOME}/.cos

echo ""
echo "Executing: '$@'"
# Execute any supplied command
exec "$@"
