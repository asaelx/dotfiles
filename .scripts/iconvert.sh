#!/usr/bin/env bash

dir=$1
output=$2

for video in "$1"/*.{mp4,MP4,m4v,mkv,webm}
do
    if [ -e "$video" ]
    then
        filename=$(basename "$video")
        name="${filename%.*}"
        converted="$name""_h265.mp4"

        echo "=> Converting $video"

	ffmpeg -i "$video" -c:v libx265 -tag:v hvc1 -pix_fmt yuv420p -c:a aac -b:a 128k -movflags +faststart "$output/$converted"

        echo "=> Done!"
    fi
done
