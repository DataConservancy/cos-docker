FROM python:2.7

MAINTAINER Data Conservancy <dc-ird@googlegroups.com>
LABEL description="Checks out and installs dependencies from the OSF repository"

ENV SHARED /shared
ENV CODE ${SHARED}/code
ENV WHEELHOUSE ${SHARED}/wheelhouse/27

ENV OSF_REPO=https://github.com/CenterForOpenScience/osf.io.git OSF_BRANCH=develop \
    DJANGO_SETTINGS_MODULE=api.base.settings \
    UPDATE_CMD="invoke clean && invoke wheelhouse --release && invoke requirements --release && gosu www-data invoke assets && gosu www-data python manage.py collectstatic --noinput"

# Volumes from the 'vols' Dockerfile
WORKDIR $CODE

RUN git clone -b $OSF_BRANCH $OSF_REPO . \
    && cp website/settings/local-dist.py website/settings/local.py \
    && chown -R www-data:www-data $CODE

RUN invoke wheelhouse --dev \
    && invoke requirements --base --dev
