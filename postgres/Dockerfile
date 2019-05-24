FROM postgres:9.6

COPY wait-for-postgres /wait-for-postgres
COPY 01-create-users-and-databases.sh /docker-entrypoint-initdb.d/
