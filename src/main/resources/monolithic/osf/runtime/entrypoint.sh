#!/bin/ash
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
# For every include file, interpolate it and then append it to the local
# settings file

for INCLUDE_FILE in `find . -name "local-docker.py.inc"` ;
do
  LOCAL_SETTINGS_FILE=`dirname $INCLUDE_FILE`/local.py
  if [ -f $LOCAL_SETTINGS_FILE ] ;
  then
    # Interpolate and append runtime environment variables to the local settings
    # file.
    echo "Interpolating ${INCLUDE_FILE} and appending it to ${LOCAL_SETTINGS_FILE}"
    cat ${INCLUDE_FILE} | envsubst >> ${LOCAL_SETTINGS_FILE}

    echo "Local settings file ${LOCAL_SETTINGS_FILE}:"
    cat ${LOCAL_SETTINGS_FILE}
    echo ""
  fi
done

echo "Executing $@"
# Execute any supplied command
exec "$@"
