FROM frolvlad/alpine-python-machinelearning AS base
LABEL maintainer="Andy MacKinlay <andy.mackinlay@cultureamp.com>"

FROM base AS builder
ENV INSTALL_PATH /install
RUN mkdir -p $INSTALL_PATH
WORKDIR /
RUN apk add --update bash
RUN apk add --no-cache build-base python3-dev 
RUN pip install --prefix="$INSTALL_PATH" --no-warn-script-location spacy==2.1 
RUN find $INSTALL_PATH \
        \( -type d -a -name test -o -name tests \) \
        -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
        -exec rm -rf '{}' +

FROM base
COPY --from=builder /install /usr/local
RUN runDeps="$( \
        scanelf --needed --nobanner --recursive /usr/local \
                | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
                | sort -u \
                | xargs -r apk info --installed \
                | sort -u \
    )" \
    && apk add $runDeps \
