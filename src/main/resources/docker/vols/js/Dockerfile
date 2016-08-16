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
    BOWER_REGISTRY=${SHARED}/bower/registry \
    BOWER_LINKS=${SHARED}/bower/links \
    BOWER_PACKAGES=${SHARED}/bower/packages \
    OSF_REPO=https://github.com/emetsger/osf.io.git \
    OSF_BRANCH=develop

RUN apk update   && \
  apk add git && \
  apk add gettext && \
  rm -rf /var/cache/apk

# npm configuration
# - sets a global cache directory
RUN npm config set cache ${NPM_CACHE} -g

# bower configuration
# - sets package, links, and registry directory
COPY bowerrc.tmpl ${TMP}
RUN cat ${TMP}/bowerrc.tmpl | envsubst > ~/.bowerrc && cat ~/.bowerrc

# Install NPM dependencies from the OSF package.json file into the npm cache directory
# Then install bower-managed dependencies under ${SHARED}/bower

WORKDIR ${TMP}

RUN \

    # Clone the OSF git repository, which contains the requirements being installed
    git clone --depth=1 -b $OSF_BRANCH $OSF_REPO osf \
    && cd osf \
    && cp website/settings/local-dist.py website/settings/local.py \

    # Install npm dependencies from 'package.json'
    # - stored in ${NPM_CACHE}
    && npm -d install || cat /tmp/osf/npm-debug.log \

    # Set permissions on the cache
    && chown -R nobody:nobody ${NPM_CACHE} \

    # Install bower-managed dependencies 
    && node_modules/bower/bin/bower --allow-root prune \
    && node_modules/bower/bin/bower --allow-root install \

    # Set permissions on bower files
    && chown -R nobody:nobody ${SHARED}/bower

    # Clean up
    && cd .. \
    && rm -rf osf

RUN find ${NPM_CACHE} -type f -o -type d \
    && find ${SHARED}/bower -type f -o type d


# Export the NPM cache as a Docker volume

VOLUME ${NPM_CACHE}

# Export the Bower cache as a Docker volume

VOLUME ${SHARED}/bower
