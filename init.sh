#!/usr/bin/env bash

if [[ "$OSTYPE" == "linux-gnu" ]]
then
    ln -s ./.config $HOME/.config
elif [[ "$OSTYPE" == "darwin"* ]]
then
    dotlist=( ".vimrc" ".aliases" ".tmux.conf" )
    for dot in "${dotlist[@]}"
    do
        src=$(pwd)/$dot
        dst=$HOME/$dot
        ln -sfn $src $dst
    done
fi
