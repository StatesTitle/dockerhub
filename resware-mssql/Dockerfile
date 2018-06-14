FROM microsoft/mssql-server-linux:2017-latest

ENV DOCKERIZE_VERSION v0.6.1

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get dist-upgrade -y && \
    apt-get -y autoremove && \
    apt-get clean && \
    apt-get install -y wget && \
    apt-get install zip -y -V && \
    apt-get install python-pip -y && \
    apt-get install python-dev -y && \
    apt-get install build-essential -y && \
    pip install awscli

RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

COPY load-backup.sh /
COPY cmd.sh /

CMD [ "sh", "/cmd.sh" ]