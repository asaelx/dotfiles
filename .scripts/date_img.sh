#!/usr/bin/env bash

Color_Off='\033[0m'
Green='\033[0;32m'
Blue='\033[0;34m'

event=$1
# count=1

for image in $PWD/*.{jpg,jpeg,JPG,JPEG,png,PNG,heic,HEIC}
do
    if [ -f "$image" ]
    then
        filename=$(basename "$image")
        name="${filename%.*}"
        extension="${filename##*.}"
        # count_str=$(printf "%03d" $count)
        date_taken=$(exif "$image" | grep 'Date and Time' | head -n 1 | awk -F '|' '{print $2}'| sed 's/:/_/g' | sed 's/ /_/g')
        name="${event}_${date_taken}.${extension}"

        echo -e "${Green}=>${Color_Off} Renaming ${Blue}$image${Color_Off} to ${Green}$name${Color_Off}"
        mv "$image" "$name"
        ((count++))
    fi
done
