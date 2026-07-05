#!/bin/bash

TORRENT_DIR="$HOME/Downloads"
TRANSMISSION_CMD="transmission-remote"

GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
NC="\033[0m"

found_any=false

find "$TORRENT_DIR" -type f -name "*.torrent" | while read -r torrent_file; do
  found_any=true
  echo -e "${YELLOW}Adding:${NC} $torrent_file"
  $TRANSMISSION_CMD --add "$torrent_file"

  if [[ $? -eq 0 ]]; then
    echo -e "${GREEN}Removed:${NC} $torrent_file"
    rm "$torrent_file"
  else
    echo -e "${RED}Failed to add:${NC} $torrent_file"
  fi
done

if ! $found_any; then
  echo -e "${YELLOW}No .torrent files found in $TORRENT_DIR${NC}"
fi
