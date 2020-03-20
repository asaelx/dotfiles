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
    )
elif [[ "$OSTYPE" == "darwin"* ]]
then
    dotlist=( ".vimrc" ".aliases" ".tmux.conf" )
fi

for dot in "${dotlist[@]}"
do
    src=$(pwd)/$dot/
    dst=$HOME/$dot
    echo $dst
    # echo -e "${Green}=> Creating symbolic link${Color_Off} $src ${Green}=>${Color_Off} ${Blue}$dst${Color_Off}"
    # ln -sfn $src $dst
done
