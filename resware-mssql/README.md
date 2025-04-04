# resware-mssql

This image is used to restore a zipped backup ResWare database.

### Required Environment Variables

- `ACCEPT_EULA`
- `MSSQL_PID`
- `SA_PASSWORD`
- `RESWARE_DATABASE_NAME`
- `BACKUP_ZIP_NAME`
- `BACKUP_FILE_NAME`
- `S3_BUCKET_NAME`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

### Optional Environment Variables
- `FORCE_BACK_UP_LOAD`
- `RUN_LOAD_BACKUP`

### Example Docker commands

1. Build Docker image

  ```
  docker build .
  ```

1. Create container from built image

  ```
  docker run -e ACCEPT_EULA=Y -e MSSQL_PID=Enterprise -e SA_PASSWORD=someGoodPass! -d -p 1433:1433 <image>
  ```

1. Optionally load backup as part of container start-up

  ```
  docker run -e ACCEPT_EULA=Y -e MSSQL_PID=Enterprise -e SA_PASSWORD=someGoodPass! -e RUN_LOAD_BACKUP=Y -e RESWARE_DATABASE_NAME=ResWare -e BACKUP_ZIP_NAME=backup.zip -e BACKUP_FILE_NAME=backup.bak -e S3_BUCKET_NAME=data-dir -e AWS_ACCESS_KEY_ID=<Access Key ID> -e AWS_SECRET_ACCESS_KEY=<Secret Access Key> -e FORCE_BACK_UP_LOAD=N -d -p 1433:1433 <image>
  ```

1. Attach to container and complete configuration and restoration of ResWare Database

  ```
  docker exec -e SA_PASSWORD=someGoodPass! -e RESWARE_DATABASE_NAME=ResWare -e BACKUP_ZIP_NAME=backup.zip -e BACKUP_FILE_NAME=backup.bak -e S3_BUCKET_NAME=data-dir -e AWS_ACCESS_KEY_ID=<Access Key ID> -e AWS_SECRET_ACCESS_KEY=<Secret Access Key> -e FORCE_BACK_UP_LOAD=N <container> ./load-backup.sh
  ```

### Helpful tips to build docker image locally

#### Avoiding SSL errors due to ZScaler
Add the following lines to add Zscaler certs 

```
FROM mcr.microsoft.com/mssql/server:2017-CU18-ubuntu-16.04

COPY ZscalerRootCertificate.crt /usr/local/share/ca-certificates/

# Update CA certificates
RUN apt-get update && \
    apt-get install -y ca-certificates && \
    update-ca-certificates
```