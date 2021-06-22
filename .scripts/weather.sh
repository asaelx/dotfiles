#!/usr/bin/env bash

export PATH=$HOME/.nvm/versions/node/v16.3.0/bin:$PATH

weather -C Mexico -c Monterrey | grep Temperature | awk '{print $2}'
