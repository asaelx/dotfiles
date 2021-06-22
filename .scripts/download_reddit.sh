#!/usr/bin/env bash

# Requires bdfr - Bulk Downloader For Reddit

username=$1

python3 -m bdfr download $HOME/Pictures/Reddit --submitted --folder-scheme $username --no-dupes --user $username
