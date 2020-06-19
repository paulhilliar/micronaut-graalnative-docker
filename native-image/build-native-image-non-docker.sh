#!/usr/bin/env bash
pushd ..
/Library/Java/JavaVirtualMachines/graalvm-ce-java11-20.1.0/Contents/Home/lib/svm/bin/native-image --no-server -cp target/micronaut-graalnative-docker-0.1.jar
popd
