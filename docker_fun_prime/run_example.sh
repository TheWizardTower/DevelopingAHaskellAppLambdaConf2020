#!/usr/bin/env bash

cp ../02_stack_script.hs tmp
pushd ../stack-build
stack install --local-bin-path=../docker_fun_prime/tmp/
popd

podman build .

