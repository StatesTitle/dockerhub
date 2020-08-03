# dockerhub

This repo contains images hosted on Docker Hub

### Add New Image
1. Add new folder containing `Dockerfile` (`<Dockerfile directory>`)
1. Log into [docker hub](https://hub.docker.com/), navigate to statestitle organization
1. Create new **Repository** under statestitle organization
1. Customize autobuild tags, change master branch Dockerfile Location to `<Dockerfile directory>/Dockerfile`
1. Build image locally

	```
	 docker build --tag statestitle/<Dockerfile directory> ./<Dockerfile directory>
	```
1. Login to docker
    ```
	 docker login
	```
1. Push initial image

	```
	 docker push statestitle/<Dockerfile directory name>:latest
	```
1. Create commit and check-in new `Dockerfile`