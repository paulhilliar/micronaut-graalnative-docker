#!/usr/bin/env bash
set -x
rm -rf tmp
mkdir tmp
cp ../target/micronaut-graalnative-docker-0.1.jar tmp/

docker build -t micronaut-graalnative-docker .

rm -rf tmp
