#!/usr/bin/env bash

username=$1
folder="/run/media/asaelx/STUFF/Pictures/Insta"

if [[ -d "$folder/$username" ]]
then
    echo "=> It does exist!"
else
    echo "=> [x] Not found!"
fi
