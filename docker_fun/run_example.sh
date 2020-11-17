#!/usr/bin/env bash

cp -r ../stack-build tmp/
cp ../00_runghc.hs tmp/
cp ../02_stack_script.hs tmp/

podman build .
