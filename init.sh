#!/usr/bin/env bash

rsync -var --exclude="README.md" --exclude=".git" --exclude=".gitignore" --exclude="init.sh" . ~;
