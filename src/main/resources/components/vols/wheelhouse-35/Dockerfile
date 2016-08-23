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
FROM alpine:3.4

# Checks out the Waterbutler code, and builds wheels (a binary format)
# for each dependency.  The wheels are placed in a wheelhouse
# (analgous to a local Maven repository).  Later, these dependencies
# can be installed from the wheelhouse, instead of being 
# re-downloaded each time.

MAINTAINER Data Conservancy <dc-ird@googlegroups.com>
LABEL description = "Provides shared data volume for Python wheels (aka a wheelhouse)" 

# Set environment variables

ENV SHARED=/shared TMP=/tmp
ENV WHEELHOUSE=${SHARED}/wheelhouse
ENV WB_REPO=https://github.com/CenterForOpenScience/waterbutler.git WB_BRANCH=develop

WORKDIR ${TMP}

# Download OSF Python dependencies as wheels, and store them in the wheelhouse
# (think Maven storing artifacts in a local Maven repository)
#
# Performed in one large RUN command to minimize image size

RUN \

    # Install Alpine packages
    # - includes dependencies necessary for python and python wheels

    apk update   && \
    apk add bash && \
    apk add python3 && \
    apk add python3-dev && \
    apk add libffi-dev && \
    apk add libxslt-dev && \
    apk add libxml2-dev && \
    apk add openssl-dev && \
    apk add gcc && \
    apk add musl && \
    apk add musl-dev && \
    apk add linux-headers && \
    apk add git && \
    apk add gosu \
            --allow-untrusted \
            --update-cache    \   
            --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ && \

    # Install pip, invoke, uwsgi, and wheel

    python3 -m ensurepip && \
      rm -r /usr/lib/python*/ensurepip && \
      pip3 install --upgrade pip setuptools && \
      rm -r /root/.cache && \

     pip install -U pip && \
       pip install \
          invoke==0.11.1 \
          uwsgi==2.0.13.1 \
          wheel && \

    # Clone the WB git repository, which contains the requirements being installed
    git clone --depth=1 -b $WB_BRANCH $WB_REPO wb \
    && cd wb \

    # Install the Python development dependencies as 'wheels' in the WHEELHOUSE_PATH
    && WHEELHOUSE=${WHEELHOUSE}/35 invoke wheelhouse --develop \

    # Set permissions on the wheelhouse
    && chown -R nobody:nobody ${WHEELHOUSE}/35 \

    # Clean up
    && cd .. \
    && rm -rf wb && \

    apk del bash && \
    apk del python3 && \
    apk del python3-dev && \
    apk del libffi-dev && \
    apk del libxslt-dev && \
    apk del libxml2-dev && \
    apk del openssl-dev && \
    apk del gcc && \
    apk del musl && \
    apk del musl-dev && \
    apk del linux-headers && \
    apk del git && \
    apk del gosu && \
    rm -rf /var/cache/apk

# Export the wheelhouse as a Docker volume

VOLUME ${WHEELHOUSE}/35
