#!/usr/bin/env bash

dir="/home/asaelx/Downloads/cosplays/vertical"
while read p; do
    ffmpeg -i "./$p" -vf "transpose=1" "$dir/$p" < /dev/null
done < $1
