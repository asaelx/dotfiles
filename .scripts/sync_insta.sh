#!/usr/bin/env bash

rsync -varhuP --remove-source-files /home/asaelx/Pictures/Insta/ /run/media/asaelx/STUFF/Backups/Insta

if [ "$?" -eq "0" ]
then
    rm -rf /home/asaelx/Pictures/Insta/*
    echo "=> Done!"
else
    echo "=> Error in rsync!"
fi
