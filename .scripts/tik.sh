#!/usr/bin/env bash

user=$1

cd $HOME/Downloads

vim -s ~/Documents/macro links.txt

mkdir -p "$user" &&

mv links.txt "$user" &&

cd "$user" &&

cat links.txt | xargs -n 1 youtube-dl
