#!/usr/bin/env bash

file=$1
extension="${file##*.}"
random="$(ran).$extension"
Color_Off='\033[0m'
Green='\033[0;32m'
Blue='\033[0;34m'

echo -e "${Green}=>${Color_Off} Renaming ${Blue}$file${Color_Off} to ${Green}$random${Color_Off}"

mv "$PWD/$file" "$PWD/$random"

