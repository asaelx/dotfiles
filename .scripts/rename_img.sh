#!/usr/bin/env bash

for i in "$PWD"/*.{jpg,JPG}
do
    mv $i "$PWD"/$(ran).jpg
done
