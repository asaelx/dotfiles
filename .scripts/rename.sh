#!/usr/bin/env bash

username=$1
for file in /home/asaelx/Downloads/*.{jpg,mp4}
do
    if [ -e "$file" ]
    then
        rname "$file" "$1_{{f}}"
    fi
done

sort
