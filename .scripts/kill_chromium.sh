#!/usr/bin/env bash

ps aux | grep -ie chromium | awk '{print $2}' | xargs kill -9 | ts '[%Y-%m-%d %H:%M:%S]'
