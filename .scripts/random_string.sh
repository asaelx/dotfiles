#!/usr/bin/env bash

LC_CTYPE=C
head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo ''
