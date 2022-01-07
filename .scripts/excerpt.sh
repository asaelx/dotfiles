#!/usr/bin/env bash

url=$3
from=$1
to=$2

ffmpeg -ss $from -to $to -i $(yt-dlp --get-url -f best "$url") $PWD/$(ran).mp4
