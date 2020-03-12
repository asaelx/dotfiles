#!/usr/bin/env bash

killall -q compton

compton -b --config ~/.config/compton/compton.conf
