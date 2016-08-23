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
set -vx

echo "Entrypoint begin."

echo "Current working directory: `/bin/pwd`"
echo "Dirty file: `ls -la .osf-init.dirty`"

if [ ! -f .osf-init.dirty ] ;
then
  echo "The OSF source code has already been initialized.  If you want to re-initialize it, you will need to create a new container from the osf-init image."
  exit 0
fi

# npm configuration
# - sets a global cache directory to a Docker volume from the 'vols/js' image
echo "NPM config"
npm config set cache ${NPM_CACHE} -g

# bower configuration
# - sets a packages directory to a Docker volume from the 'vols/js' image
echo "Bower" 
cat ${TMP}/bowerrc.tmpl | envsubst > ~/.bowerrc && cat ~/.bowerrc && \

# Install python dependencies from the wheelhouse 'vols/wheelhouse:2.7' image
echo "Requirements"
cat ${TMP}/invoke.yaml
invoke -f ${TMP}/invoke.yaml requirements --base --dev 

echo "npm install (TODO: handle this in a volume)"
npm install -q

echo "build_js_config_files"
invoke -f ${TMP}/invoke.yaml build_js_config_files

echo "webpack"
invoke -f ${TMP}/invoke.yaml webpack --dev

#echo "collectstatic"
#gosu nobody python manage.py collectstatic --noinput

rm .osf-init.dirty

echo "Entrypoint complete."
