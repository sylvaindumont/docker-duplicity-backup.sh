
FROM alpine:3.4

RUN set -x \
 && apk add --no-cache \
    ca-certificates \
    duplicity \
    openssh \
    openssl \
    rsync \
    lftp \
    mailx \
    bash

RUN apk add --no-cache --virtual build-deps \
    linux-headers \
    build-base \
    python-dev \
    libffi-dev \
    openssl-dev \
    py-setuptools \
    py-pip \
 && pip install --trusted-host pypi.python.org \
    gsutil \
    s3cmd \
    mega.py \
    python-swiftclient \
    python-keystoneclient \
 && rm -r ~/.cache/pip \
 && apk del build-deps

ADD https://github.com/zertrin/duplicity-backup.sh/raw/dev/duplicity-backup.sh /usr/local/bin/

ENV HOME=/home/duplicity

RUN adduser -D -u 1896 duplicity \
 && mkdir -p ${HOME}/.cache/duplicity \
 && mkdir -p ${HOME}/.gnupg \
 && chmod -R go+rwx ${HOME}/ \
 && mkdir -p /var/log/duplicity \
 && chmod -R go+rw /var/log/duplicity/ \
 && chmod +rx /usr/local/bin/duplicity-backup.sh \
 && touch ${HOME}/dulicity-backup.conf

VOLUME ["/home/duplicity/.cache/duplicity", "/home/duplicity/.gnupg"]

USER duplicity
ENV ROOT=/data LOGDIR="/var/log/duplicity/" LOG_FILE="duplicity.log" LOG_FILE_OWNER="${USER}:${USER}" STATIC_OPTIONS="--allow-source-mismatch"

ENTRYPOINT ["/usr/local/bin/duplicity-backup.sh", "-c", "/home/duplicity/dulicity-backup.conf"]
