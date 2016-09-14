# Center For Open Science Docker Images

This repository provides Docker images for various services offered by the Center For Open Science (COS).  Currently provided are:

* `dataconservancy/cos-osf-runtime`: image for Open Science Framework UI and v2 JSON API containers
* `dataconservancy/cos-fakecas`: image for FakeCAS container
* `dataconservancy/cos-waterbutler`: image for Waterbutler, which provides storage components for OSF

Want to get to it?  Jump to [requirements](#requirements).

# Introduction

These images may be orchestrated by using the docker-compose configuration provided in [src/main/resources/monolithic/docker-compose.yaml](src/main/resources/monolithic/docker-compose.yaml).


* [Use Case](#use-case)
* [How it works](#how-it-works)
    * [Overview](#overview)
    * [Details](#details)
* [Requirements](#requirements)
* [Try It](#try-it)
* [Cleaning Up](#cleaning-up)

# Use Case

The primary use case of these Docker images is to produce Docker images of COS projects for local integration testing, using a Continuous Integration platform like Bamboo, Travis, etc.  Docker image sizes or the time to build the images is not a major concern.  The major concern is insuring that all the containers are consistent, and have reasonable start-up times.  Consistent in this context means that if multiple containers are going to be created from the same OSF.io codebase, that they all should be using the same git commit hash.  Reasonable start-up time means that containers must minimize any runtime initialization, such as source code compilation, package installation, javascript compacting, etc.  Therefore, the images can be rather large and take quite a bit of time to build, but they will be consistent and start up rapidly.  

This may seem a zero-sum proposition: you either spend time building the image (and have a rapidly starting container) or spend little time building the image at the expense of a longer startup at runtime.  Past experience has shown that having containers do a lot of work on startup led to inconsistent environments; containers would fail or hang during startup.  

Finally, image build cost is incurred once, while runtime costs are incurred each time you create a container.  Having the CI platform take the hit to building the image is the right thing to do: robust and quick start-up for your containers and let the CI platform do the heavy lifting.   

# How it works

## Overview

* Commits are pushed to COS' [osf.io GitHub](https://github.com/CenterForOpenScience/osf.io) repository
* A build is kicked off on a CI platform, executing `mvn verify` in this Maven project
    * Docker images are built from the [latest osf.io source code](https://github.com/CenterForOpenScience/osf.io)
    * Docker containers are spun up using `docker-compose`
    * Integration tests execute against the endpoints exposed by the Docker containers (e.g. the OSF v2 HTTP API)
        * There is no support for executing integration tests "inside of" a container; they must execute against some endpoint that is exposed by the container: a HTTP port, database port, etc.
    * Docker images are pushed to the [Docker Hub](http://hub.docker.com/u/dataconservancy) if successful

The purpose of the integration tests in _this_ project are to insure the viability of the Docker containers and their orchestration with `docker-compose`.  Essentially the integration tests provided by this project are glorified sanity checks of the images, container orchestration, and runtime.

It is anticipated that _external_ projects will have specific integrations with COS projects.  Those external projects may depend on the images produced by this project, and perform project-specific integration tests against the images produced here.

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
1. Create a Docker machine that will be used to run the containers, and make it your active machine:
    * Create the machine:
        * On Mac or Linux: `docker-machine create -d virtualbox --virtualbox-disk-size 40000 --virtualbox-memory "2048" osf-docker-test`
        * On Windows: ??
    * Make it your active machine: `eval $(docker-machine env osf-docker-test)`
1. Java 8
    * `java -version`
1. A modern Maven (3.3.x)
    * `mvn -v`
1. Git    

# Try it

1. Install and verify [requirements](#requirements)
1. Clone this repository
1. Consult the output of the command line command `docker-machine env osf-docker-test`
1. Export the following environment variables:
    * DOCKER_MACHINE_NAME (the name of the Docker machine that will contain your CoS-related Docker images and containers)
        * On \*nix: `export DOCKER_MACHINE_NAME=osf-docker-test`
        * Windows command line: `set DOCKER_MACHINE_NAME=osf-docker-test`
    * DOCKER_MACHINE_IP (the IP address assigned to your `osf-docker-test` Docker machine)    
        * On \*nix: <code>export DOCKER_MACHINE_IP=\`docker-machine inspect ${DOCKER_MACHINE_NAME} --format '{{ .Driver.IPAddress }}'\`</code>
        * Windows command line:
            * Note the IP of the `osf-docker-test` Docker machine from the output of `docker-machine ls`
            * Run: `set DOCKER_MACHINE_IP=value of the IP address`
1. **Optional:** Set the following _system properties_ (by invoking Maven with `-D<propertyName>=<propertyValue>`)
    * `osf.repo` (the GitHub repository url containing the OSF.io code you wish to build)
        * Defaults to `https://github.com/emetsger/osf.io`
    * `osf.branch` (the name of the branch in ${OSF_REPO} that you want to build from)
        * Defaults to `docker-support`
    * `wb.repo` (the GitHub repository url containing the Waterbutler code you wish to build)
        * Defaults to `https://github.com/CenterForOpenScience/waterbutler`
    * `wb.branch` (the name of the branch in ${WB_REPO} that you want to build from)
        * Defaults to `develop`
1. Run `mvn verify` (or, if providing system properties from above: `mvn verify -D<propertyName>=<propertyValue>`)
1. Make a pizza from scratch, including crust.
1. Consult output of `mvn verify`
    * Insure build success
    * `docker images | grep dataconservancy` should include
        * `dataconservancy/cos-osf-runtime`
        * `dataconservancy/cos-fakecas`
        * `dataconservancy/cos-waterbutler`
1. cd `target/classes/monolithic/` and invoke `docker-compose up`
1. After successful startup, you should be able to point your web browser to `http://${DOCKER_MACHINE_IP}:5000/` and `http://${DOCKER_MACHINE_IP}:8000/v2/`.

# Cleaning up

As a developer you may find that you wish to re-build the Docker images in this project.  To do so involves three steps (assuming you are in the base directory of this repository):

1. Shut down and dispose of any existing containers: `(cd target/classes/monolithic && docker-compose down)`
1. Removal of the three Docker images produced by this project:
    * `docker rmi dataconservancy/cos-waterbutler`
    * `docker rmi dataconservancy/cos-osf-runtime`
    * `docker rmi dataconservancy/cos-cos-fakecas`
1. Remove files from the Maven `target/` directory: `mvn clean`

At this juncture you should be able to make any local changes (e.g. editing a Dockerfile) and re-run `mvn verify` to pick up those changes and re-build the images.
