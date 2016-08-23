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

MAINTAINER Data Conservancy <dc-ird@googlegroups.com>
LABEL description = "Provides shared data volume for OSF.io codebase"

# Set environment variables

ENV SHARED=/shared TMP=/tmp
ENV CODE=${SHARED}/code
ENV OSF_REPO=https://github.com/emetsger/osf.io.git OSF_BRANCH=develop

WORKDIR ${CODE}

RUN \
    
    # Install Alpine packages
    apk update && \
      apk add git && \

    # Clone the Git repository
    git clone -b $OSF_BRANCH $OSF_REPO osf.io \
    && cd osf.io \
 
    # Create a local settings file
    && cp website/settings/local-dist.py website/settings/local.py \
   
    # Set permissions
    && chown -R nobody:nobody ${CODE}/osf.io && \

    # Clean up Alpine packages
    apk del git && \
    rm -rf /var/cache/apk

VOLUME ${CODE}/osf.io

CMD [ "/bin/true" ]
