# Micronaut / Micronaut Data JDBC / GraalVM native / Docker example

This example is adapted from the Micronaut data JDBC example (https://github.com/micronaut-projects/micronaut-data/tree/master/examples/example-jdbc)


## Building:
* Build the shaded jar using Maven
* Run build-native-image-docker.sh to build the GraalVM native image

Output will be a docker image.  You can see the size of the built image using

`docker image ls micronaut-graalnative-docker`

Building:
```bash
$ mvn clean install 
$ cd build-native-image-docker
$ ./build-native-image-docker.sh
```

The Dockerfile is a two stage build.
The first stage runs using the (very large - 1gb+) `oracle/graalvm-ce:latest` image and will build the binary for the server
The second stage takes the built binary and wraps it into a much smaller Docker image

Note: Compiling GraalVM native images takes several minutes.  So the first stage above could be prettty lengthy.
However because the native image build is happening within Docker then no software needs to be installed - it's all within the base image for the first docker build stage  

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
