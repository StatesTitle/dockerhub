FROM postgres:12.9-alpine

COPY wait-for-postgres /wait-for-postgres
COPY 01-create-users-and-databases.sh 10-possibly-load-backup.sh /docker-entrypoint-initdb.d/
VOLUME /dumps
