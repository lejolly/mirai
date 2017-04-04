#!/bin/bash
echo "building mirai"
./build.sh debug telnet
echo "building single loader"
gcc -std=c99 tools/single_load.c -g -lm -lpthread -w -o debug/single_load
echo "building hello world"
gcc -std=c99 tools/hello_world.c -g -o debug/hello_world
