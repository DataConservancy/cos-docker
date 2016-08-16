FROM alpine:3.4

MAINTAINER Data Conservancy <dc-ird@googlegroups.com>
LABEL description = "Provides shared data volume for OSF.io codebase"

# Set environment variables

ENV SHARED=/shared TMP=/tmp
ENV CODE=${SHARED}/code
ENV OSF_REPO=https://github.com/CenterForOpenScience/osf.io.git OSF_BRANCH=develop

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
