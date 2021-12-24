#!/usr/bin/env bash

for file in "$PWD"/*.{jpg,jpeg,JPG,png,PNG,gif,mov,mp4,MP4,txt}
do
    if [[ -f "$file" ]]
    then
        filename=$(basename "$file")
        name="${filename%.*}"
        extension="${filename##*.}"
        if [[ "$extension" == "jpg" ]]
        then
            echo "=> Renaming $file"
            mv "$file" $(ran).jpg
        elif [[ "$extension" == "jpeg" ]]
        then
            echo "=> Renaming $file"
            mv "$file" $(ran).jpg
        elif [[ "$extension" == "JPG" ]]
        then
            echo "=> Renaming $file"
            mv "$file" $(ran).jpg
        elif [[ "$extension" == "png" ]]
        then
            echo "=> Converting $file"
            convert "$file" $(ran).jpg && rm "$file"
        elif [[ "$extension" == "PNG" ]]
        then
            echo "=> Converting $file"
            convert "$file" $(ran).jpg && rm "$file"
        elif [[ "$extension" == "gif" ]]
        then
            echo "=> Converting $file"
            ffmpeg -i "$file" -c:v libx264 -c:a aac $(ran).mp4 && rm "$file"
        elif [[ "$extension" == "mov" ]]
        then
            echo "=> Converting $file"
            ffmpeg -i "$file" -c:v libx264 -c:a aac $(ran).mp4 && rm "$file"
        elif [[ "$extension" == "mp4" ]]
        then
            echo "=> Renaming $file"
            mv "$file" $(ran).mp4
        elif [[ "$extension" == "MP4" ]]
        then
            echo "=> Renaming $file"
            mv "$file" $(ran).mp4
        elif [[ "$extension" == "txt" ]]
        then
            echo "=> Removing $file"
            rm "$file"
        fi
    fi
done
