FROM python:3.5

MAINTAINER Data Conservancy <dc-ird@googlegroups.com>
LABEL description = "Provides shared data volume for Waterbutler codebase"

# Set environment variables

ENV SHARED=/shared TMP=/tmp
ENV CODE=${SHARED}/code
ENV WHEELHOUSE=${SHARED}/wheelhouse/35
ENV WB_REPO=https://github.com/CenterForOpenScience/waterbutler.git WB_BRANCH=develop

WORKDIR ${CODE}

RUN git clone -b $WB_BRANCH $WB_REPO wb \
    && chown -R www-data:www-data ${CODE}/wb

VOLUME ${CODE}/wb
