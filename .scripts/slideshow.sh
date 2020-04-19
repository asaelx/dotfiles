#!/usr/bin/env bash

find $PWD -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.JPG" -o -name "*.png" -o -name "*.PNG" \) | mpv -fs --image-display-duration=3 --loop-playlist --playlist=-
