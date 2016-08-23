# Center For Open Science Docker Images

This repository provides Docker images for various services offered by the Center For Open Science (COS).  Currently provided are:

* Open Science Framework UI
* Open Science Framework v2 JSON API
* FakeCAS
* Service containers: rabbitmq, elasticsearch, tokumx

These images may be orchestrated by using the docker-compose configuration provided in [src/main/resources/monolithic/osf/docker-compose.yaml](src/main/resources/monolithic/osf/docker-compose.yaml).

# Use Case

The primary use case of these Docker images is to produce Docker images of COS projects for local integration testing, using a Continuous Integration platform like Bamboo, Travis, etc.  Docker image sizes or the time to build the images is not a major concern.  The major concern is insuring that all the containers are consistent, and have reasonable start-up times.  Consistent in this context means that if multiple containers are going to be created from the same OSF.io codebase, that they all should be using the same git commit hash.  Reasonable start-up time means that containers must minimize any runtime initialization, such as source code compilation, package installation, javascript compacting, etc.  Therefore, the images can be rather large and take quite a bit of time to build, but they will be consistent and start up rapidly.  

This may seem a zero-sum proposition: you either spend time building the image (and have a rapidly starting container) or spend little time building the image at the expense of a longer startup at runtime.  Past experience has shown that having containers do a lot of work on startup led to inconsistent environments.  Often containers would fail or hang during startup.  We should also note that a secondary goal is to enable developers to also use these images. Finally, image build cost is incurred once, while runtime costs are incurred each time you create a container.  Having the CI platform take the hit to building the image is the right thing to do: robust and quick start-up for your containers and let the CI platform do the heavy lifting.   

# How it works

## Overview

* Commits are pushed to COS' [osf.io GitHub](https://github.com/CenterForOpenScience/osf.io) repository
* A build is kicked off on a CI platform, executing `mvn verify` in this Maven project
    * Docker images are built from the [latest osf.io source code](https://github.com/CenterForOpenScience/osf.io)
    * Docker containers are spun up using `docker-compose`
    * Integration tests execute against the endpoints exposed by the Docker containers (e.g. the OSF v2 HTTP API)
        * There is no support for executing integration tests "inside of" a container; they must execute against some endpoint that is exposed by the container: a HTTP port, database port, etc.
    * Docker images are pushed to the [Docker Hub](http://hub.docker.com/u/DataConservancy) if successful

## Details

1. `Dockerfile`s are hand-coded and hand-tested.  When developing a `Dockerfile`, iterating is much more efficient using the `docker` and `docker-compose` CLI.  Once the `Dockerfile` has been developed and tested in a developers environment, it can be put into Maven.
1. Instructions for building an image from the `Dockerfile` are created and maintained in the Maven [pom.xml](pom.xml), using the [fabric8io docker-maven-plugin](https://github.com/fabric8io/docker-maven-plugin).  Note that the plugin uses the `Dockerfile` for all build instructions.  The purpose is to insure the portability and integrity of the `Dockerfile`, so no plugin directives like `<cmd>` or `<entryPoint>` are used.
1. The Docker images are spun up using the [Mojohaus exec-maven-plugin](http://www.mojohaus.org/exec-maven-plugin/).  We want to test the functionality of the container orchestration itself, which provided by the `docker-compose.yaml` file, so the `docker-maven-plugin` `docker:start` goal is not used.
1. Integration tests execute against the newly built images. These are your normal Java classes that execute during the `integration-test` phase by the failsafe plugin.  (TODO)
1. If the integration tests succeed, the images are published to the Docker Hub. (TODO)

# Requirements

1. Install `docker-machine` and `docker-compose`, which can be found in the [Docker Toolbox](https://www.docker.com/products/docker-toolbox)
    * Insure that both commands are on your command path
    * The goal is to isolate the images and containers produced by this project from the CI platform environment, and to require stand-alone tools that can be installed by a systems administrator to support these builds.  Currently "Docker for Mac" and "Docker for Windows" is not supported.  They may be supported in the future if they can be reasonably tested.
1. Create a Docker machine that will be used to run the containers and execute ITs
    * On Mac or Linux: `docker-machine create -d virtualbox --virtualbox-disk-size 40000 --virtualbox-memory "2048" osf-docker-test`
    * On Windows: ??
1. Java 8
    * `java -version`
1. A modern Maven (3.3.x)
    * `mvn -v`
1. Git    

# Try it

1. Clone this repository
1. Consult the output of `docker-machine env osf-docker-test`
1. Edit `pom.xml` (note this step will be deprecated in the future, but somehow the local Docker environment must be communicated to Maven).  Find the `<properties>` section, and edit the values for the following, copying the values from the previous step:
    * `docker.host.url`
    * `docker.machine.name`
1. Run `mvn verify`
1. Make a pizza from scratch, including crust.
1. Consult output of `mvn verify`
