#!/usr/bin/env bash

img_duration=3
extensions='.*\.\(jpg\|jpeg\|JPG\|png\|PNG\|mp4\|MP4\|mkv\|mov\|MOV\|webm\)'

find "$PWD" -type f -regex $extensions | sort -R | mpv -fs --image-display-duration=$img_duration --loop-playlist --playlist=-
