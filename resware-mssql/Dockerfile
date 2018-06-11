FROM microsoft/mssql-server-linux:2017-latest

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get dist-upgrade -y && \
    apt-get -y autoremove && \
    apt-get clean && \
    apt-get install zip -y -V && \
    apt-get install python-pip -y && \
    apt-get install python-dev -y && \
    apt-get install build-essential -y && \
    pip install awscli

COPY load-backup.sh /