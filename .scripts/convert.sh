#!/usr/bin/env bash

dir="/home/asaelx/Downloads/cosplays/converted"
while read p; do
    filename=$(basename -- "$p")
    extension="${filename##*.}"
    name="${filename%.*}"
    if [ $extension == "webm" ]
    then
        ffmpeg -i "./$p" -c:v libx264 -c:a aac "$dir/$name.mp4" < /dev/null
    fi
done < $1


