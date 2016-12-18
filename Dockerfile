
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
    build-base \
    python-dev \
    libffi-dev \
    openssl-dev \
    py-setuptools \
    py-pip

RUN pip install --trusted-host pypi.python.org \
    gsutil \
    s3cmd \
    mega.py \
    python-swiftclient \
    python-keystoneclient \
 && rm -r ~/.cache/pip \
 && apk del build-deps

RUN adduser -D -u 1896 duplicity \
 && mkdir -p /home/duplicity/.cache/duplicity \
 && mkdir -p /home/duplicity/.gnupg \
 && chmod -R go+rwx /home/duplicity/

ENV HOME=/home/duplicity
ENV ROOT=/data

VOLUME ["/home/duplicity/.cache/duplicity", "/home/duplicity/.gnupg"]

USER duplicity

ADD https://github.com/zertrin/duplicity-backup.sh/raw/dev/duplicity-backup.sh /usr/local/bin/

ENTRYPOINT ["bash", "/usr/local/bin/duplicity-backup.sh"]
