###################
# First stage is to use docker image to build the native image under linux
# it needs to be built within Docker (not locally on your laptop) because the compiled binary will be native
# so needs to be built under Linux.  Using this technique we can build Linux-native binaries
# from anywhere
FROM oracle/graalvm-ce:latest as build-native-image

# install the GraalVM native image builder utility
RUN gu install native-image

# copy in the jar built by maven
COPY tmp/micronaut-graalnative-docker-0.1.jar .

# Build the native image
# using --static means that we can use a smaller base image for the second stage e.g. oraclelinux:latest
RUN native-image --no-server --static -cp micronaut-graalnative-docker-0.1.jar


###################
# Second stage - build an image with just the compiled graalvm binary

# using scratch for the second stage base image gives the smallest possible image - 72.6MB
FROM scratch

# Using alpine gives a more useful base image but the image size is slightly larger - 78.2MB
#FROM alpine:latest

# copy from the first build stage to the root of the result image
COPY --from=build-native-image /micronaut-graalnative-docker /

EXPOSE 8080
ENTRYPOINT ["./micronaut-graalnative-docker"]
