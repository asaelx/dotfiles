#!/usr/bin/env bash

Color_Off='\033[0m'
Green='\033[0;32m'
Blue='\033[0;34m'
Red='\033[0;31m'

for file in "$PWD"/*.{jpg,jpeg,JPG,png,PNG,gif,mov,MOV,mp4,MP4,txt}
do
    if [[ -f "$file" ]]
    then
        filename=$(basename "$file")
        extension="${filename##*.}"

        case "$extension" in
            jpg | jpeg | JPEG | JPG)
                echo -e "${Green}=>${Color_Off} Renaming ${Blue}$file${Color_Off}"
                mv "$file" $(ran).jpg
                ;;
            png | PNG)
                echo -e "${Green}=>${Color_Off} Converting ${Blue}$file${Color_Off}"
                convert "$file" $(ran).jpg && rm "$file"
                ;;
            gif | mov | MOV)
                echo -e "${Green}=>${Color_Off} Converting ${Blue}$file${Color_Off}"
                ffmpeg -i "$file" -c:v libx264 -c:a aac $(ran).mp4 && rm "$file"
                ;;
            mp4 | MP4)
                echo -e "${Green}=>${Color_Off} Renaming ${Blue}$file${Color_Off}"
                mv "$file" $(ran).mp4
                ;;
            txt)
                echo -e "${Red}=>${Color_Off} Removing ${Red}$file${Color_Off}"
                rm "$file"
                ;;
            esac
    fi
done

