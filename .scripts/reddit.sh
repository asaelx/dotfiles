#!/usr/bin/env bash

# Requires bdfr - Bulk Downloader For Reddit

username=$1

# Subreddit
# python3.9 -m bdfr download $HOME/Pictures/Reddit --subreddit $username --folder-scheme $username --no-dupes

# User
python3.9 -m bdfr download $HOME/Pictures/Reddit --submitted --folder-scheme $username --no-dupes --user $username

cd $HOME/Pictures/Reddit/$username

$HOME/.scripts/rename_img.sh
