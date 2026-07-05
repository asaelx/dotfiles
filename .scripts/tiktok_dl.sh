#!/usr/bin/env bash

# TikTok Downloader CLI Tool
# Author: ChatGPT
# Description: Downloads TikTok videos from a list, supports cookies, clipboard username, and destination override.

# Default values
USERNAME=$(pbpaste | tr -d '[:space:]')
DEST_DIR="$HOME/Pictures/Tiktok"
LINKS_FILE="$HOME/Downloads/links.log"
AUTO_COOKIES_FILE="$HOME/Downloads/tiktok.com_cookies.txt"

# ANSI Colors
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
RESET="\033[0m"

# Manual
show_help() {
  echo -e "${CYAN}Usage: tiktok-dl.sh [OPTIONS]${RESET}"
  echo ""
  echo "Options:"
  echo "  -u, --username <username>        Specify the TikTok username (default: clipboard contents)"
  echo "  -d, --destination <directory>   Set the destination parent folder (default: ~/Pictures/Tiktok)"
  echo "  -l, --links <file>              Set the file with TikTok links (default: ~/Downloads/links.log)"
  echo "  -h, --help                      Show this help message and exit"
}

# Argument parsing
while [[ "$#" -gt 0 ]]; do
  case $1 in
    -u|--username)
      USERNAME="$2"
      shift
      ;;
    -d|--destination)
      DEST_DIR="$2"
      shift
      ;;
    -l|--links)
      LINKS_FILE="$2"
      shift
      ;;
    -h|--help)
      show_help
      exit 0
      ;;
    *)
      echo -e "${RED}Unknown option: $1${RESET}"
      show_help
      exit 1
      ;;
  esac
  shift
done

# Final paths
USER_DIR="$DEST_DIR/$USERNAME"

# Create destination folder
mkdir -p "$USER_DIR"

# Move links.log if it's the default path
if [[ "$LINKS_FILE" == "$HOME/Downloads/links.log" && -f "$LINKS_FILE" ]]; then
  mv "$LINKS_FILE" "$USER_DIR/"
  LINKS_FILE="$USER_DIR/links.log"
  echo -e "${YELLOW}Moved links.log to $USER_DIR/${RESET}"
fi

# Validate links file
if [[ ! -f "$LINKS_FILE" ]]; then
  echo -e "${RED}❌ Links file not found at $LINKS_FILE${RESET}"
  exit 1
fi

# Count total links
TOTAL_LINKS=$(wc -l < "$LINKS_FILE" | tr -d '[:space:]')
echo -e "${CYAN}📥 Found $TOTAL_LINKS links to download.${RESET}"

# Build yt-dlp command
CMD=(yt-dlp -a "$LINKS_FILE" -P "$USER_DIR")

if [[ -f "$AUTO_COOKIES_FILE" ]]; then
  CMD+=(--cookies "$AUTO_COOKIES_FILE")
  echo -e "${YELLOW}🔐 Using cookies from: $AUTO_COOKIES_FILE${RESET}"
else
  echo -e "${YELLOW}ℹ️ No cookies file detected. Continuing without cookies.${RESET}"
fi

# Run download
echo -e "${CYAN}🚀 Starting download...${RESET}"
YT_OUTPUT=$("${CMD[@]}" 2>&1)
echo "$YT_OUTPUT" > "$USER_DIR/yt-dlp-output.log"

# Accurate success/failure count based on video IDs
SUCCESS_COUNT=0
FAIL_COUNT=0

while IFS= read -r url; do
  video_id=$(echo "$url" | grep -oE '[0-9]{19}')
  if grep -q "$video_id" "$USER_DIR/yt-dlp-output.log"; then
    SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
  else
    FAIL_COUNT=$((FAIL_COUNT + 1))
  fi
done < "$LINKS_FILE"

# Summary output
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "📊  Download Summary"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${GREEN}✅ Successfully downloaded:${RESET} $SUCCESS_COUNT"
echo -e "${RED}❌ Failed to download:     ${RESET} $FAIL_COUNT"
echo -e "${YELLOW}📁 Saved to:              ${RESET} $USER_DIR/"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
