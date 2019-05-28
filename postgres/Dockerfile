FROM postgres:9.6

COPY wait-for-postgres /wait-for-postgres
COPY 01-create-users-and-databases.sh 10-possibly-load-backup.sh /docker-entrypoint-initdb.d/
VOLUME /dumps

