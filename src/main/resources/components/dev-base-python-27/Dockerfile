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
FROM mhart/alpine-node-auto:6.3.1

MAINTAINER Data Conservancy <dc-ird@googlegroups.com>
LABEL description = "Provides Python 2.7, Django, pip, invoke, uwsgi, wheel, nodejs (with npm), and gosu."

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
