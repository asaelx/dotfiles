#!/usr/bin/env bash

head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo ''
