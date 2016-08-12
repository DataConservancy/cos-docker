FROM python:2.7

MAINTAINER Data Conservancy <dc-ird@googlegroups.com>
LABEL description = "Provides shared data volume for OSF.io codebase"

# Set environment variables

ENV SHARED=/shared TMP=/tmp
ENV CODE=${SHARED}/code
ENV WHEELHOUSE=${SHARED}/wheelhouse/27
ENV OSF_REPO=https://github.com/CenterForOpenScience/osf.io.git OSF_BRANCH=develop

WORKDIR ${CODE}

RUN git clone -b $OSF_BRANCH $OSF_REPO osf.io \
    && cd osf.io \
    && cp website/settings/local-dist.py website/settings/local.py \
    && chown -R www-data:www-data ${CODE}/osf.io

VOLUME ${CODE}/osf.io
