#!/usr/bin/env bash

url=$1
tsfile=$PWD/$2
tmpdir=/tmp/slicer
partsdir="$tmpdir/parts"
currentdir=$PWD

mkdir -p "$partsdir"
cd $tmpdir
yt-dlp "$url" --cookies $HOME/Downloads/youtube.com_cookies.txt

for file in "$tmpdir"/*.{webm,mkv,mp4}
do
    if [ -e "$file" ]
    then
        filename=$(basename "$file")
        name="${filename%.*}"
        extension="${filename##*.}"
        if [ "$extension" != "mp4" ]
        then
            converted="$name.mp4"
            ffmpeg -i "$file" -c:v libx264 -c:a aac "$converted" < /dev/null
            rm -rf "$file"
            filename=$converted
        fi
    fi
done

part=1

while read ts
do
    tstart=$(echo "$ts" | awk '{print $1}')
    tend=$(echo "$ts" | awk '{print $2}')
    part_str=$(printf "%02d" $part)
    ffmpeg -ss $tstart -to $tend -i "$filename" -c:v libx264 -c:a aac "$partsdir/$part_str.mp4" < /dev/null
    ((part++))
done < "$tsfile"

rm -rf "$filename"

find $partsdir -type f -name '*.mp4' | /usr/bin/sort | awk '{print "file " "\x27" $1 "\x27"}' > files.txt

ffmpeg -f concat -safe 0 -i files.txt -c copy "$currentdir/$filename" < /dev/null

rm -rf "$tmpdir"
