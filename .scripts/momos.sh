#!/usr/bin/env bash
export PATH=$HOME/.nvm/versions/node/v13.9.0/bin:$PATH

node ~/Code/collectogram/index.js | ts '[%Y-%m-%d %H:%M:%S]'
