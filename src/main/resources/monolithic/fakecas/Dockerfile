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
LABEL description = "Provides a runnning instance of fakecas on port 8080"

ARG FAKECAS_VERSION
ARG FAKECAS_ARCH

ENV FAKECAS_VERSION=${FAKECAS_VERSION:-0.8.0} \
    FAKECAS_ARCH=${FAKECAS_ARCH:-linux-386}

# Downloads a release that incorporates PRs that have not been incorporated upstream
ENV FAKECAS_URL=https://github.com/emetsger/fakecas/releases/download/${FAKECAS_VERSION}-use-host/fakecas-${FAKECAS_ARCH}

RUN \

  mkdir -p /opt/fakecas && \
    cd /opt/fakecas && \

  # Install curl
  apk --no-cache update && \
    apk --no-cache add \
      curl && \

  # Download the release to the current directory, and name it 'fakecas'
  echo "Downloading fakecas from ${FAKECAS_URL}" && \
  curl -SL -o fakecas ${FAKECAS_URL} && \
  chmod 700 ./fakecas && \

  # Cleanup
  apk --no-cache del curl

WORKDIR /opt/fakecas

ENTRYPOINT [ "./fakecas" ]

CMD [ "-dbaddress", "tokumx:27017", "-host", "0.0.0.0:8080" ]
