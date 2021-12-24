#!/usr/bin/env bash

dir=$1
output=$2

for video in "$1"/*.{mp4,MP4,mkv,webm}
do
    if [ -e "$video" ]
    then
        filename=$(basename "$video")
        name="${filename%.*}"
        converted="$name""_h265.mp4"

        echo "=> Converting $video"

        ffmpeg -i "$video" -c:v libx265 -c:a aac "$output/$converted"

        echo "=> Done!"
    fi
done

