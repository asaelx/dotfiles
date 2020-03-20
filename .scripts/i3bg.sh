#!/usr/bin/env bash

IMG1=$(realpath $1)
IMG2=$(realpath $2)
IMG1OUT="/home/asaelx/Pictures/Walls/hdmi.jpg"
IMG2OUT="/home/asaelx/Pictures/Walls/dvi.jpg"
IMGLOCK="/home/asaelx/Pictures/Walls/lock.jpg"

convert $IMG1 -resize 3840x2160^ -gravity Center -extent 3840x2160 $IMG1OUT
convert $IMG2 -resize 1080x1920^ -gravity Center -extent 1080x1920 $IMG2OUT

convert $IMG1OUT $IMG2OUT +append $IMGLOCK

rm -rf $IMG1OUT $IMG2OUT

betterlockscreen -u $IMGLOCK
