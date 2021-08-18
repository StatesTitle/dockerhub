FROM python:3.7.11-slim

ENV MD5_HASH 38a27d391a2b03214b444cb13d5664f1
ENV THRIFT_VERSION 0.13.0

RUN set -x && \
    dependencies='wget automake bison curl flex g++ gcc git libboost-all-dev libevent-dev libmagic-dev libssl-dev libtool make pkg-config' && \
    apt-get update --fix-missing && apt-get install --fix-broken -y --no-install-recommends $dependencies && \
    wget --output-document /tmp/thrift-${THRIFT_VERSION}.tar.gz https://downloads.apache.org/thrift/${THRIFT_VERSION}/thrift-${THRIFT_VERSION}.tar.gz && \
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

CMD echo "thrift v.$THRIFT_VERSION"
