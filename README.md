# Center For Open Science Docker Images

This repository provides Docker images for various services offered by the Center For Open Science.  Currently provided are:

* Open Science Framework UI
* Open Science Framework v2 JSON API
* FakeCAS
* Service containers: rabbitmq, elasticsearch, tokumx

These images may be orchestrated by using the docker-compose configuration provided in [src/main/resources/monolithic/osf/docker-compose.yaml](src/main/resources/monolithic/osf/docker-compose.yaml).

# How it works

1. `Dockerfile`s are hand-coded and hand-tested.  When developing a `Dockerfile`, iterating is much more efficient using the `docker` and `docker-compose` CLI.  Once the `Dockerfile` has been developed, it can be put into Maven.
2. Instructions for building an image from the `Dockerfile` are created and maintained in the Maven [pom.xml](pom.xml), using the [Spotify docker-maven-plugin](https://github.com/spotify/docker-maven-plugin) .
3. Integration tests execute against the newly built images.
4. If the integration tests succeed, the images are published to the Docker Hub.


