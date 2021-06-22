#!/usr/bin/env bash

Color_Off='\033[0m'
Green='\033[0;32m'
Blue='\033[0;34m'

echo -e "${Green}=> Archiving...${Color_Off}"

rsync -varzhiuP --remove-source-files $HOME/Pictures/Insta/ /run/media/asaelx/STUFF/Pictures/Insta &&

if [ "$?" -eq "0" ]
then
    echo -e "${Blue}=> Deleting folders...${Color_Off}"
    trash $HOME/Pictures/Insta/*
    echo -e "${Green}=> Done!${Color_Off}"
else
    echo -e "${Green}=> Error in rsync!${Color_Off}"
fi
