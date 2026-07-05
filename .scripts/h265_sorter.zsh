#!/bin/zsh

set -euo pipefail

DRY_RUN=false

# Parse arguments
if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
  echo "Running in DRY RUN mode. No files will be moved."
fi

# Check dependency
if ! command -v ffprobe >/dev/null 2>&1; then
  echo "Error: ffprobe not found. Install with: brew install ffmpeg"
  exit 1
fi

# Create folders if not in dry run
if [[ "$DRY_RUN" == false ]]; then
  mkdir -p optimized
  mkdir -p others
fi

echo "Scanning directory..."

# Only regular files in current directory
for file in *(.N); do
  [[ -d "$file" ]] && continue

  case "${file:l}" in
    *.mp4|*.mkv|*.mov|*.avi|*.webm) ;;
    *) continue ;;
  esac

  echo "Checking: $file"

  codec=$(ffprobe -v error \
    -select_streams v:0 \
    -show_entries stream=codec_name \
    -of default=noprint_wrappers=1:nokey=1 \
    -- "$file" 2>/dev/null)

  if [[ "$codec" == "hevc" ]]; then
    if [[ "$DRY_RUN" == true ]]; then
      echo "  → Would move '$file' to optimized/"
    else
      echo "  → Moving '$file' to optimized/"
      mv -- "$file" optimized/
    fi
  else
    if [[ "$DRY_RUN" == true ]]; then
      echo "  → Would move '$file' to others/ (codec: ${codec:-unknown})"
    else
      echo "  → Moving '$file' to others/ (codec: ${codec:-unknown})"
      mv -- "$file" others/
    fi
  fi
done

echo "Finished."
