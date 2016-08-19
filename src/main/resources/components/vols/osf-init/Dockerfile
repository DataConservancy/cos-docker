FROM dataconservancy/cos-dev-base:python-2.7

MAINTAINER Data Conservancy <dc-ird@googlegroups.com>
LABEL description = "Provides an initialized shared data volume for OSF.io codebase"

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

COPY invoke.yaml ${TMP}/invoke.yaml

# bower configuration
# - sets registry directory

COPY bowerrc.tmpl ${TMP}

WORKDIR ${CODE}

RUN \

    # Fix Alpine cache
    mkdir -p /var/cache/apk && \
      ln -s /var/cache/apk /etc/apk/cache && \    

    # Install Alpine packages
    apk update && \
      apk add git && \
      apk add gettext && \

    # Clone the Git repository
    git clone -b $OSF_BRANCH $OSF_REPO . \
 
    # Create a local settings file
    && cp website/settings/local-dist.py website/settings/local.py \
   
    # Set permissions
    && chown -R nobody:nobody ${CODE} && \

    # Clean up Alpine packages (leave gettext and git, used by entrypoint)
    rm -rf /var/cache/apk && \

    # Indicate to other containers that this 
    # container is not fully initialized 
    # (initialization occurs in the entrypoint)

    touch .osf-init.dirty

VOLUME ${CODE}

COPY entrypoint.sh /

RUN chmod 700 /entrypoint.sh

# Entrypoint expects volumes from 'vols/js' and 'vols/wheelhouse-27'
# - installs bower dependencies
# - installs npm dependencies
# - installs python dependencies

ENTRYPOINT [ "/entrypoint.sh" ]
