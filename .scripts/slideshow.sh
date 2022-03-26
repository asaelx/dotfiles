#!/usr/bin/env bash

img_duration=3
extensions='.*.(jpg|jpeg|JPG|png|PNG|mp4|MP4|mkv|mov|MOV|webm)'

find -E "$PWD" -type f -regex $extensions | sort -R | mpv --image-display-duration=$img_duration --loop-playlist --playlist=-
