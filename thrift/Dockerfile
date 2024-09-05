FROM python:3.11.4-slim

ENV MD5_HASH aadebde599e1f5235acd3c730721b873
ENV THRIFT_VERSION 0.20.0

RUN set -x && \
dependencies='wget automake bison flex g++ git libboost-all-dev libevent-dev libssl-dev libtool make pkg-config' && \
    apt-get update --fix-missing && apt-get install --fix-broken -y --no-install-recommends $dependencies && \
    wget --output-document /tmp/thrift-${THRIFT_VERSION}.tar.gz https://archive.apache.org/dist/thrift/${THRIFT_VERSION}/thrift-${THRIFT_VERSION}.tar.gz && \
    [ $(md5sum /tmp/thrift-${THRIFT_VERSION}.tar.gz | cut -d' ' -f1) = $MD5_HASH ] && \
    tar -xf /tmp/thrift-${THRIFT_VERSION}.tar.gz -C /tmp && \
    rm /tmp/thrift-${THRIFT_VERSION}.tar.gz && \
    cd /tmp/thrift-${THRIFT_VERSION} && \
    ./bootstrap.sh && \
    ./configure --prefix=/usr/local/ --enable-libs=no && \
    make && \
    make install && \
    rm -rf /tmp/thrift-${THRIFT_VERSION} && \
    apt-get purge -y --auto-remove $dependencies

# curl is needed for Heroku UI log visibility
RUN apt-get update && apt-get install -y --no-install-recommends curl

CMD echo "thrift v.$THRIFT_VERSION"
