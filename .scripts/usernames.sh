#!/usr/bin/env sh

for img in $PWD/*.PNG;
do
    mkdir -p usernames
    convert "$img" -crop 780x130+252+590 $PWD/usernames/$(ran).jpg
done
