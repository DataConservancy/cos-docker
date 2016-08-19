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
