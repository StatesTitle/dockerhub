#!/usr/bin/env sh

set -e

# If RUN_LOAD_BACKUP is not set, or is set to N, attempt to load backup
if [ -z "${RUN_LOAD_BACKUP+N}" ] || [ "${RUN_LOAD_BACKUP}" = "N" ];
then
    /opt/mssql/bin/sqlservr
else
    echo "Running sqlservr in background..."
    /opt/mssql/bin/sqlservr &
    BG_PID=$!
    dockerize -wait tcp://localhost:1433 -timeout 1m
    echo 'Loading backup...'
    . /load-backup.sh
    echo "Waiting for sqlservr to terminate..."
    wait $BG_PID
fi
