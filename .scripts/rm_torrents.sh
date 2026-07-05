#!/bin/bash

TRANSMISSION_CMD="transmission-remote"

GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
NC="\033[0m"

echo -e "${YELLOW}Fetching torrent list...${NC}"

$TRANSMISSION_CMD --list | tail -n +2 | sed '$d' | while read -r line; do
  id=$(echo "$line" | awk '{print $1}')
  percent=$(echo "$line" | awk '{print $2}' | tr -d '%')

  if [[ "$percent" == "100" ]]; then
    echo -e "${GREEN}Removing completed torrent ID $id${NC}"
    $TRANSMISSION_CMD -t "$id" --remove
  fi
done
