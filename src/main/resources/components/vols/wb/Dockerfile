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
LABEL description = "Provides shared data volume for Waterbutler codebase"

# Set environment variables

ENV SHARED=/shared TMP=/tmp
ENV CODE=${SHARED}/code
ENV WHEELHOUSE=${SHARED}/wheelhouse/35
ENV WB_REPO=https://github.com/CenterForOpenScience/waterbutler.git WB_BRANCH=develop

WORKDIR ${CODE}

RUN \
    
    # Install Alpine packages
    apk update && \
      apk add git && \

    # Clone the git repository
    git clone -b $WB_BRANCH $WB_REPO wb && \

    # Set permissions
    chown -R nobody:nobody ${CODE}/wb && \

    # Clean up Alpine packages
    apk del git && \
    rm -rf /var/cache/apk

VOLUME ${CODE}/wb
