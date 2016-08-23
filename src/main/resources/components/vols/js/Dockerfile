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
FROM mhart/alpine-node-auto:6.3.1

# Checks out the OSF code, and installs Node.js packages found
# in 'package.json'.  Then installs bower-managed javascript packages.
# The packages are placed in a cache, and re-used later, instead of 
# re-installing the packages.

MAINTAINER Data Conservancy <dc-ird@googlegroups.com>
LABEL description = "Provides shared data volume for Node.js (npm) and Bower packages" 

# Set environment variables

ENV SHARED=/shared TMP=/tmp
ENV NPM_CACHE=${SHARED}/npm \
    BOWER_PACKAGES=${SHARED}/bower/packages \
    OSF_REPO=https://github.com/emetsger/osf.io.git \
    OSF_BRANCH=develop

WORKDIR ${TMP}

# bower configuration
# - sets registry directory
COPY bowerrc.tmpl ${TMP}

RUN \
    
    # Install Alpine packages
    apk update && \
      apk add git && \
      apk add gettext && \
      apk add coreutils && \
      apk add python && \
      apk add make && \
      apk add musl && \
      apk add musl-dev && \
      apk add gcc && \
      apk add g++ && \

    # npm configuration
    # - sets a global cache directory, ultimately exported as a Docker volume
    npm config set cache ${NPM_CACHE} -g && \

    # bower configuration
    # - sets a packages directory, ultimately exported as a Docker volume
    cat ${TMP}/bowerrc.tmpl | envsubst > ~/.bowerrc && cat ~/.bowerrc && \

    # Clone the OSF git repository, which contains the requirements being installed
    git clone --depth=1 -b $OSF_BRANCH $OSF_REPO osf \
    && cd osf \
    && cp website/settings/local-dist.py website/settings/local.py \

    # Install npm dependencies from 'package.json'
    # - stored in ${NPM_CACHE}
    && PYTHON=/usr/bin/python npm -q install || cat /tmp/osf/npm-debug.log \

    # Set permissions on the cache
    && chown -R nobody:nobody ${NPM_CACHE} \

    # Install bower-managed dependencies 
    && node_modules/bower/bin/bower -q --allow-root prune \
    && node_modules/bower/bin/bower -q --allow-root install \

    # Set permissions on bower files
    && chown -R nobody:nobody ${SHARED}/bower \

    # Clean up
    && cd / && \
    apk del gettext && \
      apk del git && \
      apk del coreutils && \
      apk del python && \
      apk del make && \
      apk del musl && \
      apk del musl-dev && \
      apk del gcc && \
      apk del g++ && \

    rm -rf /var/cache/apk && \
    rm -rf ${TMP}/*

# Export the NPM cache as a Docker volume

VOLUME ${NPM_CACHE}

# Export the Bower cache as a Docker volume

VOLUME ${SHARED}/bower

CMD [ "/bin/true" ]
