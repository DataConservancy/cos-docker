#FROM alpine:3.4
FROM mhart/alpine-node-auto:6.3.1

MAINTAINER Data Conservancy <dc-ird@googlegroups.com>
LABEL description = "Provides Python 2.7, pip, invoke, uwsgi, wheel, nodejs, and gosu."

# Install packages, then remove the cache
# - includes dependencies necessary for python and python wheels

RUN apk update   && \
  apk add bash && \
  apk add python && \
  apk add python-dev && \
  apk add py-pip && \ 
  apk add libffi-dev && \
  apk add libxslt-dev && \
  apk add libxml2-dev && \
  apk add openssl-dev && \
  apk add gcc && \
  apk add g++ && \
  apk add musl && \
  apk add musl-dev && \
  apk add linux-headers && \
  apk add git && \
  apk add curl && \
  apk add make && \
  apk add paxctl && \
  apk add libgcc && \
  apk add libstdc++ && \
  apk add gnupg && \
  apk add gosu \
          --allow-untrusted \
          --update-cache    \   
          --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ && \
  rm -rf /var/cache/apk

# Install pip, invoke, uwsgi, and wheel

RUN pip install -U pip && \
      pip install \
        invoke==0.13.0 \
        uwsgi==2.0.13.1 \
        wheel
