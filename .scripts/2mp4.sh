#!/usr/bin/env bash

video=$1
filename=$(basename "$video")
name="${filename%.*}"
converted="$name""_h264.mp4"

echo "=> Converting $video"

ffmpeg -i "$video" -c:v libx264 -c:a aac "$PWD/$converted"

echo "=> Done!"
