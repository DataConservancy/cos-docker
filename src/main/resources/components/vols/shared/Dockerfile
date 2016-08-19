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
