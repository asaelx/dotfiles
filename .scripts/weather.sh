#!/usr/bin/env bash

export PATH=$HOME/.nvm/versions/node/v13.11.0/bin:$PATH

weather | grep Temperature | awk '{print $2}'
