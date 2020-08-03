#!/usr/bin/env bash

if ls /dumps/*.dump 1> /dev/null 2>&1; then
    /wait-for-postgres
    for f in /dumps/*.dump ; do
        service_name=$(echo ${f} | sed -e 's/\/dumps\/latest-st-// ; s/.dump// ; s/--staging// ; s/-/_/')
        if [[ "$POSTGRES12_DATABASE_NAMES" == *"$service_name"* ]] ; then
            # Ignore errors in the restore as it attempts to drop tables first
            pg_restore --verbose --clean --no-acl --no-owner -U postgres -d "$service_name" "$f" || true
        fi
    done
fi
