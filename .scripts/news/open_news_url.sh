#!/usr/bin/env bash

url=$(cat $HOME/.scripts/news/current_news.txt | awk -F ";" '{print $2}')

brave "$url"
