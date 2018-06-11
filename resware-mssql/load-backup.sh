#!/usr/bin/env sh

MDF_FILE=${RESWARE_DATABASE_NAME}
LDF_FILE=${RESWARE_DATABASE_NAME}
RESTORE_DB="RESTORE DATABASE [${RESWARE_DATABASE_NAME}] 
    FROM DISK = N'/var/opt/mssql/data/backups/${BACKUP_FILE_NAME}'
    WITH
    REPLACE,
    RECOVERY,
    MOVE N'ResWare' TO N'/var/opt/mssql/data/${MDF_FILE}.mdf',
    MOVE N'ResWare_log' TO N'/var/opt/mssql/data/${LDF_FILE}_log.LDF'"

# Download Backup zip from AWS
aws s3 cp s3://st-resware-db-bak-data/${BACKUP_ZIP_NAME} ./${BACKUP_ZIP_NAME}

# Unzip Backup
unzip -o ./${BACKUP_ZIP_NAME} -d /var/opt/mssql/data/backups/

# Restore Database
/opt/mssql-tools/bin/sqlcmd -S localhost,1433 -U SA -P ${SA_PASSWORD} -Q "${RESTORE_DB}"

# Remove Files
rm -f ./${BACKUP_ZIP_NAME}
rm -f /var/opt/mssql/data/backups/${BACKUP_FILE_NAME}