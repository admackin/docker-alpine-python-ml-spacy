FROM frolvlad/alpine-python-machinelearning
LABEL maintainer="Andy MacKinlay <andy.mackinlay@cultureamp.com>"

RUN apk add --update bash

RUN apk add --no-cache --virtual .build-deps \
  build-base python3-dev \
    && pip install --no-cache-dir spacy==2.1 \
    && find /usr/local \
        \( -type d -a -name test -o -name tests \) \
        -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
        -exec rm -rf '{}' + \
    && runDeps="$( \
        scanelf --needed --nobanner --recursive /usr/local \
                | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
                | sort -u \
                | xargs -r apk info --installed \
                | sort -u \
    )" \
    && apk add --virtual .rundeps $runDeps \
    && apk del .build-deps
