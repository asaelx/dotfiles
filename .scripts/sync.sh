#!/usr/bin/env bash

hdd="/Volumes/BLACK/Insta"
pinsta="$HOME/Pictures/Insta"

rsync -varzhiuP --remove-source-files "$pinsta/" $hdd && trash $HOME/Pictures/Insta/*
