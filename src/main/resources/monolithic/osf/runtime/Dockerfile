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

MAINTAINER Data Conservancy <dc-ird@googlegroups.com>
LABEL description = "Provides runtime suitable for the v2 API or OSF UI"

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
ARG OSF_REPO
ARG OSF_BRANCH

# Provide sane default values for environment
# variables, but prefer the ARG version if it
# is available.

ENV SHARED=${SHARED:-/shared} TMP=${TMP:-/tmp}
ENV CODE=${CODE:-${SHARED}/code/osf.io} \
    WHEELHOUSE=${WHEELHOUSE:-${SHARED}/wheelhouse/27} \
    NPM_CACHE=${NPM_CACHE:-${SHARED}/npm} \
    BOWER_PACKAGES=${BOWER_PACKAGES:-${SHARED}/bower/packages} \
    OSF_REPO=${OSF_REPO:-https://github.com/emetsger/osf.io.git}  \
    OSF_BRANCH=${OSF_BRANCH:-develop}

# Python Invoke configuration
# - avoids configuring a pty, to avoid unicode encoding errors like:
#   "UnicodeEncodeError: 'ascii' codec can't encode characters in position 18-20: ordinal not in range(128)"

COPY invoke.yaml ${TMP}

# Bower configuration
# - sets registry directory

COPY bowerrc.tmpl ${TMP}

RUN mkdir -p ${CODE}

WORKDIR ${CODE}

# Download OSF Python dependencies as wheels, and store them in the wheelhouse
# (think Maven storing artifacts in a local Maven repository)
#
# Done in one large RUN to minimize the size of the image

RUN \
    # Install Alpine packages
    # - includes dependencies necessary for python and python wheels
    apk --no-cache update && \
    apk --no-cache add \
      bash \
      python \
      python-dev \
      py-pip \
      libffi-dev \
      libxslt-dev \
      libxml2-dev \
      openssl-dev \
      gcc \
      g++ \
      musl \
      musl-dev \
      linux-headers \
      git && \
    apk add \
        --allow-untrusted \
        --no-cache \
        --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ \
        gosu && \

    # Install pip, invoke, uwsgi, and wheel
    pip install -U pip && \
      pip install \
        invoke==0.13.0 \
        uwsgi==2.0.13.1 \
        wheel

RUN \
    # Clone the OSF git repository, which contains the requirements being
    # installed
    git clone -b $OSF_BRANCH $OSF_REPO . \
    && cp website/settings/local-dist.py website/settings/local.py

RUN \
    # Install the Python development dependencies as 'wheels' in the
    # WHEELHOUSE
    # - use custom Invoke configuration from /tmp/invoke.yaml
    WHEELHOUSE=${WHEELHOUSE} PYTHONIOENCODING="utf_8:ignore" \
      invoke -f ${TMP}/invoke.yaml wheelhouse --dev

RUN \
    # Install the Python addon dependencies as 'wheels' in the
    # WHEELHOUSE
    # - use custom Invoke configuration from /tmp/invoke.yaml
    WHEELHOUSE=${WHEELHOUSE} PYTHONIOENCODING="utf_8:ignore" \
      invoke -f ${TMP}/invoke.yaml wheelhouse --addons

RUN \
    # Install Python base, development, and addon dependencies from the
    # WHEELHOUSE
    WHEELHOUSE=${WHEELHOUSE} PYTHONIOENCODING="utf_8:ignore" \
      invoke -f ${TMP}/invoke.yaml requirements --quick

RUN \
    # A hack to get around some dependency conflicts with uritemplate in the
    # GitHub addon (see OSF.io /.travis.yml and /Dockerfile)
    (pip uninstall uritemplate.py --yes || true) \
          && pip install --no-cache-dir uritemplate.py==0.3.0

RUN \
    # Set permissions on the wheelhouse
    chown -R nobody:nobody ${WHEELHOUSE}

RUN \
    # Install Alpine packages
    apk --no-cache update && \
      apk --no-cache add \
        git \
        coreutils \
        make \
        musl \
        musl-dev \
        gcc \
        g++ \
        # bash required by webpack
        bash \
        # envsubst required by entrypoint
        gettext \
        # Keep these, don't `apk del` them later; runtime dependencies of
        # Python libraries
        python \
        libffi \
        libxslt \
        libxml2 \
        openssl

RUN \
    # npm configuration
    # - sets a global cache directory, ultimately exported as a Docker volume
    npm config set cache ${NPM_CACHE} -g

RUN \
    # bower configuration
    # - sets a packages directory, ultimately exported as a Docker volume
    cat ${TMP}/bowerrc.tmpl | envsubst > ~/.bowerrc

RUN \
    # Install npm dependencies from 'package.json'
    # - stored in ${NPM_CACHE}
    npm -d install

RUN \
    # Set permissions on the cache
    chown -R nobody:nobody ${NPM_CACHE}

RUN \
    # Install bower-managed dependencies
    node_modules/bower/bin/bower -q --allow-root prune && \
    node_modules/bower/bin/bower -q --allow-root install

RUN \
    # Set permissions on node modules and bower files
    chown -R nobody:nobody ${SHARED}/bower && \
    chown -R nobody:nobody ${CODE}/node_modules

RUN \
    invoke -f ${TMP}/invoke.yaml build_js_config_files

RUN \
    invoke -d -f ${TMP}/invoke.yaml webpack --dev

RUN \
    invoke -f ${TMP}/invoke.yaml copy_settings --addons

RUN \
    rm -rf ${TMP}/*

COPY website/ website/
COPY entrypoint.sh /
RUN chmod 700 /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
