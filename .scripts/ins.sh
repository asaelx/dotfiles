#!/usr/bin/env bash

instadir="$HOME/Pictures/Insta"
Color_Off='\033[0m'
Green='\033[0;32m'
Blue='\033[0;34m'

for file in $HOME/Downloads/*.{jpg,jpeg,JPG,png,mp4}
do
    if [ -e "$file" ]
    then
        echo -e "${Green}=>${Color_Off} Archiving ${Blue}$file${Color_Off}"
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
        echo -e "${Green}=>${Color_Off} Moving ${Blue}$file${Color_Off} to ${Blue}$dir${Color_Off}"
    elif [[ -f $file ]]
    then
        mkdir -p reddit
        mv "$file" reddit
        echo -e "${Green}=>${Color_Off} Moving ${Blue}$file${Color_Off} to ${Blue}reddit${Color_Off}"
    fi
done
