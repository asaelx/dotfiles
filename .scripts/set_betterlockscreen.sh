#!/usr/bin/env bash

IMG1=$(realpath $1)
IMG2=$(realpath $2)
IMG1OUT="$HOME/Pictures/Walls/dp.jpg"
IMG2OUT="$HOME/Pictures/Walls/hdmi.jpg"
IMGLOCK="$HOME/Pictures/Walls/lock.jpg"

convert $IMG1 -resize 3840x2160^ -gravity Center -extent 3840x2160 $IMG1OUT
convert $IMG2 -resize 3840x2160^ -gravity Center -extent 3840x2160 $IMG2OUT

convert $IMG1OUT $IMG2OUT +append $IMGLOCK

rm -rf $IMG1OUT $IMG2OUT

betterlockscreen -u $IMGLOCK
