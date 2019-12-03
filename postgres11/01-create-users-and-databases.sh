#!/usr/bin/env bash

/wait-for-postgres
for db in ${POSTGRES11_DATABASE_NAMES}; do
	createuser -U postgres -s ${db}
	createdb -U postgres ${db} --owner=${db}
done
