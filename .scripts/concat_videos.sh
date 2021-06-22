#!/usr/bin/env bash

list=$PWD/files.txt
output=$1

ls -tr -I "*.txt" | awk '{print "file \x27" $0 "\x27"}' > $list

ffmpeg -f concat -safe 0 -i $list -c copy $PWD/$1
