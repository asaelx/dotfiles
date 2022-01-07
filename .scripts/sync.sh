#!/usr/bin/env bash

hdd="/mnt/f/Insta"
pinsta="$HOME/Pictures/Insta"

rsync -varzhiuP --remove-source-files "$pinsta/" $hdd && rm -rf "$pinsta/*"
