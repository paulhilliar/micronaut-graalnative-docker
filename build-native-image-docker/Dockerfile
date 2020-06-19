#first stage is to use a docker image to build the native image under linux
FROM oracle/graalvm-ce:latest as build-native-image

RUN gu install native-image

COPY tmp/micronaut-graalnative-docker-0.1.jar .

RUN native-image --no-server -cp micronaut-graalnative-docker-0.1.jar


#FROM alpine:latest     if you use alpine then the native image won't run

#using oraclelinux:latest means the image is 300mb but at least it runs.  TODO find a smaller base image that still works
FROM oraclelinux:latest
#FROM adoptopenjdk/openjdk11-openj9:jdk-11.0.1.13-alpine-slim

#FROM oracle/graalvm-ce:latest  if you use this then the image is 1.3gb
COPY --from=build-native-image /micronaut-graalnative-docker /

EXPOSE 8080
ENTRYPOINT ["./micronaut-graalnative-docker"]
