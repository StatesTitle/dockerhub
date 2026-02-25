#!/usr/bin/env sh

set -e

CURRENT_BACKUP_FILE_NAME=""
CURRENT_RESWARE_DATABASE_NAME=""

# Load history file
if [ -f ./.load-backup.history ]; then
    . ./.load-backup.history
fi

# If FORCE_BACK_UP_LOAD is not set, or is set to N, check for prior art
if [ -z "${FORCE_BACK_UP_LOAD+N}" ] || [ "${FORCE_BACK_UP_LOAD}" = "N" ]; then
    # Only attempt to load backup file if different than historical file and database 
    if [ "$CURRENT_BACKUP_FILE_NAME" = "$BACKUP_FILE_NAME" ] && [ "$CURRENT_RESWARE_DATABASE_NAME" = "$RESWARE_DATABASE_NAME" ]; then
        echo "Skipping '$CURRENT_BACKUP_FILE_NAME' and '$CURRENT_RESWARE_DATABASE_NAME' already loaded..." 
        return 0
    fi
fi

# Download Backup zip from cloud storage
echo "Downloading ${BACKUP_ZIP_NAME} from ${AZURE_BLOB_CONTAINER_NAME}"
az storage blob download --container-name ${AZURE_BLOB_CONTAINER_NAME} --name ${BACKUP_ZIP_NAME} --file ./${BACKUP_ZIP_NAME}
echo "Download of DB backup file successful"

# Unzip Backup
unzip -o ./${BACKUP_ZIP_NAME} -d /var/opt/mssql/data/backups/


KILL_CONNECTIONS_IF_EXISTS="USE [master];
DECLARE @kill varchar(8000) = '';  
SELECT @kill = @kill + 'kill ' + CONVERT(varchar(5), session_id) + ';'  
FROM sys.dm_exec_sessions
WHERE database_id  = db_id('${RESWARE_DATABASE_NAME}')
EXEC(@kill);"


# Kill Database connections
/opt/mssql-tools/bin/sqlcmd -S localhost,1433 -U SA -P ${SA_PASSWORD} -Q "${KILL_CONNECTIONS_IF_EXISTS}"

RESTORE_HEADERONLY="RESTORE HEADERONLY FROM DISK = N'/var/opt/mssql/data/backups/${BACKUP_FILE_NAME}'"
/opt/mssql-tools/bin/sqlcmd -S localhost,1433 -U SA -P ${SA_PASSWORD} -Q "${RESTORE_HEADERONLY}"

RESTORE_FILELISTONLY="RESTORE FILELISTONLY FROM DISK = N'/var/opt/mssql/data/backups/${BACKUP_FILE_NAME}'"
/opt/mssql-tools/bin/sqlcmd -S localhost,1433 -U SA -P ${SA_PASSWORD} -Q "${RESTORE_FILELISTONLY}"

MDF_FILE=${RESWARE_DATABASE_NAME}
LDF_FILE=${RESWARE_DATABASE_NAME}
RESTORE_DB="RESTORE DATABASE [${RESWARE_DATABASE_NAME}] 
    FROM DISK = N'/var/opt/mssql/data/backups/${BACKUP_FILE_NAME}'
    WITH
    REPLACE,
    RECOVERY,
    MOVE N'${RESWARE_DATABASE_NAME}' TO N'/var/opt/mssql/data/${MDF_FILE}.mdf',
    MOVE N'${RESWARE_DATABASE_NAME}_log' TO N'/var/opt/mssql/data/${LDF_FILE}_log.LDF'"

# Restore Database
/opt/mssql-tools/bin/sqlcmd -S localhost,1433 -U SA -P ${SA_PASSWORD} -Q "${RESTORE_DB}"


# Remove Files
rm -f ./${BACKUP_ZIP_NAME}
rm -f /var/opt/mssql/data/backups/${BACKUP_FILE_NAME}


# Write history file
cat <<EOF >./.load-backup.history
CURRENT_BACKUP_FILE_NAME=${BACKUP_FILE_NAME}
CURRENT_RESWARE_DATABASE_NAME=${RESWARE_DATABASE_NAME}
EOF

echo "Successfully Restored $RESWARE_DATABASE_NAME from $BACKUP_FILE_NAME."
