# Steps to Upgrade Thrift Version in Docker

1. Check the latest Thrift version at https://thrift.apache.org/.

2. Verify if the latest version's tar.gz is available at https://archive.apache.org/dist/thrift/ or https://downloads.apache.org/thrift/. It is safer to use https://archive.apache.org/dist/thrift/ because if there is a new version available, they will move the older version to the archive.

3. Get the MD5 hash from the .md5 file. For example: https://archive.apache.org/dist/thrift/0.20.0/thrift-0.20.0.tar.gz.md5.

4. Update the MD5_HASH and THRIFT_VERSION in thrift/Dockerfile.

5. Build the new `statestitle/thrift` docker image: `docker image build . --file thrift/Dockerfile --tag statestitle/thrift:0.20.0`.

6. Manually push the latest image to Docker Hub: `docker push statestitle/thrift:0.20.0 `.

7. Tag the image as the latest: `docker image tag statestitle/thrift:0.20.0 statestitle/thrift:latest` and push the image to DockerHub

8. Verify the image in DockerHub https://hub.docker.com/repository/docker/statestitle/thrift/general

9. Use the SHA digest of the required Docker image version and update the project's Dockerfile. Ex: https://github.com/StatesTitle/underwriter/blob/main/bridge/Dockerfile#L88