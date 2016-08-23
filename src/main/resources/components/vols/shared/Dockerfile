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
FROM alpine:3.3

MAINTAINER Data Conservancy <dc-ird@googlegroups.com>
LABEL description = "Provides shared data volumes exposed under /shared by default, and a Samba server configured to share /shared publicly."

# Set environment variables

ENV SHARED=/shared 

# Install any packages, then remove the cache

RUN apk update   && \
  apk add openrc && \
  apk add samba  && \
  apk add samba-common-tools && \
  apk add gettext && \
  apk upgrade samba-4.4.3 \
          --allow-untrusted \
          --update-cache    \
          --repository http://dl-3.alpinelinux.org/alpine/edge/main/  && \
  rm -rf /var/cache/apk

# Samba configuration

ADD smb.conf ${SHARED}/etc/samba/smb.conf.tmpl

# The volume(s) exposed by this container

VOLUME ${SHARED}

EXPOSE 445

ADD samba-entrypoint.sh /

RUN chmod 700 /samba-entrypoint.sh

# Initializes the Samba configuration if it is missing
# Sets filesystem permissions on shared volumes
# Starts Samba

ENTRYPOINT [ "/samba-entrypoint.sh" ]
