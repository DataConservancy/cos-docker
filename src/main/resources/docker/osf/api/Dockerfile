FROM dataconservancy/cos-dev-base:python-2.7

MAINTAINER Data Conservancy <dc-ird@googlegroups.com>
LABEL description="Runtime for the the OSF.io v2 API"

ENV SHARED=/shared TMP=/tmp
ENV CODE=${SHARED}/code/osf.io \
    WHEELHOUSE=${SHARED}/wheelhouse/27 \
    NPM_CACHE=${SHARED}/npm \
    BOWER_PACKAGES=${SHARED}/bower/packages
    
#ENV OSF_REPO=https://github.com/CenterForOpenScience/osf.io.git OSF_BRANCH=develop \
#    DJANGO_SETTINGS_MODULE=api.base.settings \
#    UPDATE_CMD="invoke clean && invoke wheelhouse --release && invoke requirements --release && gosu www-data invoke assets && gosu www-data python manage.py collectstatic --noinput"

# Python Invoke configuration
# - avoids configuring a pty, to avoid unicode encoding errors like:
#   "UnicodeEncodeError: 'ascii' codec can't encode characters in position 18-20: ordinal not in range(128)"

COPY invoke.yaml ${TMP}/invoke.yaml

# bower configuration
# - sets registry directory

COPY bowerrc.tmpl ${TMP}

# Expect volumes from
# - 'vols/osf'
# - 'vols/wheelhouse-27' 
# - 'vols/js'

WORKDIR ${CODE}

RUN mkdir -p /var/cache/apk && \
      ln -s /var/cache/apk /etc/apk/cache && \
      apk update && \
      apk add gettext

COPY entrypoint.sh /

RUN chmod 700 /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "invoke", "-f", "${TMP}/invoke.yaml", "apiserver", "--host=0.0.0.0" ]
