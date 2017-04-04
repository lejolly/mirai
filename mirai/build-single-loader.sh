#!/bin/bash
gcc -std=c99 tools/single_load.c -g -lm -lpthread -w -o debug/single_load
gcc -std=c99 tools/hello_world.c -g -o debug/hello_world
