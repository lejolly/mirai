#!/bin/bash
echo "running single loader"
./debug/single_load 10.0.2.15 ./debug/input.txt ./debug/hello_world 10.0.2.16 1 1 1 |& tee ./debug/output.txt
