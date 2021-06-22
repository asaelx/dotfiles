#!/usr/bin/env bash

workdir="$HOME/.scripts/news"

jq '.articles[] | .title+ ";" +.url' $workdir/news.json | sort -R | head -n 1 | tr -d \" > $workdir/current_news.txt

echo $(date) > $workdir/cron.log
