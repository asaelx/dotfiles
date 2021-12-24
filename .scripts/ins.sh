#!/usr/bin/env bash

instadir="/mnt/c/Users/Asael/Pictures/Insta"
Color_Off='\033[0m'
Green='\033[0;32m'
Blue='\033[0;34m'

for file in /mnt/c/Users/Asael/Downloads/*.{jpg,jpeg,JPG,png,mp4}
do
    if [ -e "$file" ]
    then
        echo -e "${Green}=> Archiving${Color_Off} $file"
        mv "$file" $instadir
    fi
done

cd $instadir

find . -name '*([0-9])*' -exec rm -rf {} \;

for file in *
do
    if [[ $file == *_[A-Z0-9]* ]]
    then
        dir=${file%%_[A-Z0-9]*}
        mkdir -p $dir
        mv "$file" $dir
        echo -e "${Green}=> Moving${Color_Off} $file to ${Blue}$dir"
    elif [[ -f $file ]]
    then
        mkdir -p reddit
        mv "$file" reddit
        echo -e "${Green}=> Moving${Color_Off} $file to ${Blue}reddit"
    fi
done
