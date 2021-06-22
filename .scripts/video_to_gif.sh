#!/usr/bin/env bash

# Source: https://medium.com/@Peter_UXer/small-sized-and-beautiful-gifs-with-ffmpeg-25c5082ed733

video=$1
filename=$(basename "$video")
name="${filename%.*}"

# TODO: Create validation for video file

# Create gif from palette
ffmpeg -i $1 -filter_complex "[0:v] fps=15,scale=w=720:h=-1,split [a][b];[a] palettegen=stats_mode=single [p];[b][p] paletteuse=new=1" "$PWD/$name.gif"
