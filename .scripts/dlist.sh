#!/usr/bin/env bash

while read p; do
    youtube-dl "$p"
done < $1


