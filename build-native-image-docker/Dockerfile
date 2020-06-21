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
RUN native-image --static --no-server --no-fallback -cp micronaut-graalnative-docker-0.1.jar
RUN strip micronaut-graalnative-docker


###################
# Second (optional) stage
# compress the built binary from the first stage, to make the final image smaller.  Expansion speed isn't an issue
FROM reproio/upx:latest as upx
COPY --from=build-native-image /micronaut-graalnative-docker /micronaut-graalnative-docker.org
RUN upx --best --lzma -o /micronaut-graalnative-docker /micronaut-graalnative-docker.org



###################
# Third stage - build an image with just the compiled graalvm binary

# using scratch for the second stage base image gives the smallest possible image - 72.6MB
FROM scratch
#FROM oracle/graalvm-ce:latest  if you use this then the image is 1.3gb

# Using alpine gives a more useful base image but the image size is slightly larger - 78.2MB
#FROM alpine:latest

# copy from the previous build stage to the root of the result image
COPY --from=upx /micronaut-graalnative-docker /
EXPOSE 8080
ENTRYPOINT ["./micronaut-graalnative-docker"]
