#!/usr/bin/env bash

workdir="$HOME/.scripts/news"

title=$(cat $workdir/current_news.txt | awk -F ";" '{print $1}')

# if [[ $(ps -A | grep zscroll ) != "" ]]
# then
#     killall -q zscroll
# fi
#
# echo "$title" | zscroll -d 0.2

echo ${title:0:70}...
