# Micronaut / Micronaut Data JDBC / GraalVM native / Docker / Kubernetes example

This example is adapted from the Micronaut data JDBC example (https://github.com/micronaut-projects/micronaut-data/tree/master/examples/example-jdbc)

Problem statement:
Desire to demonstrate running Micronaut + GraalVM native within Docker (and optionally Kubernetes).

When you compile GraalVM images you are building them for the local platform (e.g. building for MacOS)

In order to run within a Docker image you need to compile the native image on Linux.

So, how do you do this?

Answer is to build the native image within Docker.

The issue with that is that a basic Docker image build will be 1.3GB, so the final piece is to make a multi stage Docker build where the built native image binary is wrapped in a smaller base image.  Thus reducing the image size from 1.3 GB to 72.6 MB

## Building:
* Build the shaded jar using Maven (`mvn clean install`)
* Run `build-native-image-docker.sh` to build the GraalVM native image

Output will be a docker image.  You can see the size of the built image using

`docker image ls micronaut-graalnative-docker`

Building:
```bash
$ mvn clean install 
$ cd build-native-image-docker
$ ./build-native-image-docker.sh
```

The Dockerfile is a multi stage build.
The first stage runs using the (very large - 1.3GB) `oracle/graalvm-ce:latest` image and will build the binary for the server

The second stage takes the built binary and comopresses it

The final stage takes the compressed binary and wraps it into a much smaller Docker image (16.1MB)

Note: Compiling GraalVM native images takes several minutes.  So the first stage above could be pretty lengthy.
However because the native image build is happening within Docker then no software needs to be installed - it's all within the base image for the first docker build stage.


Note that the reason we need to use docker to build the native image is because the native image needs to be a Linux-native binary

So we build within Docker (not locally on your laptop) because the compiled binary will be Linux-native so needs to be built under Linux.  
  

## Useful commands
To run the container normally:

`docker container run -p 8080:8080 micronaut-graalnative-docker`


Or in the background

`docker container run -d -p 8080:8080 micronaut-graalnative-docker`

Hit the example endpoints:

`curl localhost:8080/pets`

`curl localhost:8080/owners`


See the running containers

`docker ps`

Start a shell on a running docker container: 

`docker exec -it <container name> /bin/bash`

Stop all running containers (to stop the running container)

`docker stop $(docker ps -aq)`

Remove all stopped containers

`docker rm $(docker ps -a -q)`


# Building without Docker
Run `build-native-image-non-docker.sh` then start.sh to run the native image outside of Docker.
This requires GraalVM to be installed and also the GraalVM native image utility.
This should see the server start up in approx 40ms


# Running in Kubernetes
Go to the Kubernetes folder

`apply -f micronaut-graalnative-docker.deployment.yaml`

The Kubernetes deployment includes liveness/readiness probes against the Micronaut health endpoint (which is enabled in `application.yml`).

Kubernetes will ping the server `/health` endpoint to see when the container is ready/assess its ongoing healthiness.

The Kubernetes deployment exposes the same 8080 port, so the server will be accessible in the same way no matter which method you choose to run it (Graal non-Docker, within Docker, within Kubernetes)
