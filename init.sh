#!/usr/bin/env bash

Color_Off='\033[0m'
Green='\033[0;32m'
Blue='\033[0;34m'

if [[ "$OSTYPE" == "linux-gnu" ]]
then
    dotlist=(
        ".Xdefaults"
        ".vimrc"
        ".aliases"
        ".tmux.conf"
        ".config/i3"
        ".config/polybar"
        ".config/compton"
        ".config/dunst"
        ".config/mpv"
        ".scripts"
    )
elif [[ "$OSTYPE" == "darwin"* ]]
then
    dotlist=( ".vimrc" ".aliases" ".tmux.conf" ".scripts" )
fi

for dot in "${dotlist[@]}"
do
    if [[ -d $dot ]]
    then
        src=$(pwd)/$dot/
    else
        src=$(pwd)/$dot
    fi
    dst=$HOME/$dot
    echo -e "${Green}=> Creating symbolic link${Color_Off} $src ${Green}=>${Color_Off} ${Blue}$dst${Color_Off}"
    ln -sfn $src $dst
done
