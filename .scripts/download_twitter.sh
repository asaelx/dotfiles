#!/usr/bin/env bash

username=$1

python3.9 $HOME/Code/twitter_media_downloader/twitter_media_downloader.py -o $HOME/Pictures/Twitter -f "[%date%] %filename%.%ext%" -s large -u $username
