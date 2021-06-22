#!/usr/bin/env bash

progress=$(transmission-remote -l | awk '{ print $2 }' | sed '1d' | sed '$d' | xargs)

if [[ "$progress" = "" ]];
then
    echo "Nothing downloading"
else
    echo $progress
fi
