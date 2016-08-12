FROM dataconservancy/python:2.7

# Checks out the OSF code, and builds wheels (a binary format)
# for each dependency.  The wheels are placed in a wheelhouse
# (analgous to a local Maven repository).  Later, these dependencies
# can be installed from the wheelhouse, instead of being 
# re-downloaded each time.

MAINTAINER Data Conservancy <dc-ird@googlegroups.com>
LABEL description = "Provides shared data volume for Python wheels (aka a wheelhouse)" 

# Set environment variables

ENV SHARED=/shared TMP=/tmp
ENV WHEELHOUSE=${SHARED}/wheelhouse
ENV OSF_REPO=https://github.com/emetsger/osf.io.git OSF_BRANCH=develop

# Python Invoke configuration
# - avoids configuring a pty, to avoid unicode encoding errors like:
#   "UnicodeEncodeError: 'ascii' codec can't encode characters in position 18-20: ordinal not in range(128)"

COPY invoke.yaml ${TMP}/invoke.yaml

# Download OSF Python dependencies as wheels, and store them in the wheelhouse
# (think Maven storing artifacts in a local Maven repository)

WORKDIR ${TMP}

RUN \

    # Clone the OSF git repository, which contains the requirements being installed
    git clone --depth=1 -b $OSF_BRANCH $OSF_REPO osf \
    && cd osf \
    && cp website/settings/local-dist.py website/settings/local.py \

    # Install the Python development dependencies as 'wheels' in the WHEELHOUSE_PATH
    # - use custom Invoke configuration from /tmp/invoke.yaml
    && WHEELHOUSE=${WHEELHOUSE}/27 PYTHONIOENCODING="utf_8:ignore" invoke -f ${TMP}/invoke.yaml wheelhouse --dev \

    # Set permissions on the wheelhouse
    && chown -R nobody:nobody ${WHEELHOUSE}/27 \

    # Clean up
    && cd .. \
    && rm -rf osf

# Export the wheelhouse as a Docker volume

VOLUME ${WHEELHOUSE}/27
