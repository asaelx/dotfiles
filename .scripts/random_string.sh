#!/usr/bin/env bash

generate_random_string() {
  local length="${1:-13}"
  openssl rand -base64 48 | tr -dc 'A-Za-z0-9' | head -c "$length"
  echo
}

generate_random_string "$@"
