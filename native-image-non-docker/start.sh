#!/usr/bin/env bash
gdate -u +'%Y-%m-%dT%H:%M:%S.%3N%Z'

echo 'Starting GraalVM image'

../micronaut-graalnative-docker
