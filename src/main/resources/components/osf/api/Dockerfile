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
FROM dataconservancy/cos-dev-base:python-2.7

MAINTAINER Data Conservancy <dc-ird@googlegroups.com>
LABEL description="Runtime for the the OSF.io v2 API"

# Expose each environment variable as a build argument
# This allows the author of docker-compose.yaml files
# to choose between 'build' or 'image' instructions 
# and still set environment variables. (Setting
# environment variables are not supported when using
# the 'build' instruction).

ARG SHARED
ARG TMP
ARG CODE
ARG WHEELHOUSE
ARG NPM_CACHE
ARG BOWER_PACKAGES

# Provide sane default values for environment
# variables, but prefer the ARG version if it
# is available.

ENV SHARED=${SHARED:-/shared} TMP=${TMP:-/tmp}
ENV CODE=${SHARED}/code/osf.io \
    WHEELHOUSE=${WHEELHOUSE:-${SHARED}/wheelhouse/27} \
    NPM_CACHE=${NPM_CACHE:-${SHARED}/npm} \
    BOWER_PACKAGES=${BOWER_PACKAGES:-${SHARED}/bower/packages}
    
# Python Invoke configuration
# - avoids configuring a pty, to avoid unicode encoding errors like:
#   "UnicodeEncodeError: 'ascii' codec can't encode characters in position 18-20: ordinal not in range(128)"

COPY invoke.yaml ${TMP}/invoke.yaml

# bower configuration
# - sets registry directory

COPY bowerrc.tmpl ${TMP}

# Expect volumes from
# - 'vols/osf'
# - 'vols/wheelhouse-27' 
# - 'vols/js'

WORKDIR ${CODE}

ENTRYPOINT [ "/usr/bin/invoke", "-f", "/tmp/invoke.yaml", "apiserver", "--host=0.0.0.0" ]
