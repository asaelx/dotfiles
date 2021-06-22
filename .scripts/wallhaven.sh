#!/usr/bin/env bash

APIKEY="fOFs4GpskptOnRI85zStWkcx7ojKr7iq"
QUERY=$1
SORTING="toplist"
PURITY="111"
URL="https://wallhaven.cc/api/v1/search?q=$QUERY&page=1&sorting=$SORTING&purity=$PURITY&apikey\=$APIKEY"
DOWNLOAD_DIR="$HOME/Pictures/Walls"

cd $DOWNLOAD_DIR

curl -s "$URL" | jq '.data[].path' | sort -R | head -n 1 | xargs -n 1 wget
