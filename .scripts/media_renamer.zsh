#!/usr/bin/env zsh

Color_Off='\033[0m'
Green='\033[0;32m'
Blue='\033[0;34m'
Red='\033[0;31m'
Yellow='\033[1;33m'

# Defaults
PROCESS_IMAGES=1
PROCESS_VIDEOS=1
DEDUPLICATE=0
DRY_RUN=0
DEBUG=0
OUTPUT_DIR="."

show_help() {
  echo ""
  echo "USAGE:"
  echo "  $(basename "$0") [OPTIONS]"
  echo ""
  echo "DESCRIPTION:"
  echo "  Batch rename and convert images/videos to jpg/mp4 with optional duplicate removal, dry-run and debug support."
  echo ""
  echo "OPTIONS:"
  echo "  -i    Only process images"
  echo "  -v    Only process videos"
  echo "  -d    Remove duplicate files before processing (using fdupes)"
  echo "  -o <dir>  Output to specified directory (default: current directory)"
  echo "  -n    Show what would be done, but do not modify any files (dry-run)"
  echo "  -g    Show debug output"
  echo "  -h    Show this help message and exit"
  echo ""
  echo "EXAMPLES:"
  echo "  $(basename "$0") -i -d -n -o renamed -g"
  echo "  $(basename "$0") -v"
  echo ""
  echo "Supported image types: jpg, jpeg, png, tiff, bmp, webp, heic, gif"
  echo "Supported video types: mp4, mov, avi, mkv, webm, 3gp, m4v, flv"
  echo ""
}

# Debug print function
debug() {
  if (( DEBUG )); then
    echo -e "${Yellow}[DEBUG]$Color_Off $*"
  fi
}

# Function to check if a value is in an array
in_array() {
  local elem match="$1"; shift
  for elem; do
    [[ "$elem" == "$match" ]] && return 0
  done
  return 1
}

# Manual check with getopts
while getopts ":ivdngo:h" opt; do
  case $opt in
    i) PROCESS_IMAGES=1; PROCESS_VIDEOS=0 ;;
    v) PROCESS_VIDEOS=1; PROCESS_IMAGES=0 ;;
    d) DEDUPLICATE=1 ;;
    n) DRY_RUN=1 ;;
    g) DEBUG=1 ;;
    o) OUTPUT_DIR="$OPTARG" ;;
    h)
      show_help
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      show_help
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      show_help
      exit 1
      ;;
  esac
done
shift $((OPTIND - 1))

debug "AFTER PARSE: PROCESS_IMAGES=$PROCESS_IMAGES PROCESS_VIDEOS=$PROCESS_VIDEOS DEDUPLICATE=$DEDUPLICATE DRY_RUN=$DRY_RUN DEBUG=$DEBUG OUTPUT_DIR=$OUTPUT_DIR"

if [[ ! -d "$OUTPUT_DIR" ]]; then
  if (( DRY_RUN )); then
    echo -e "${Blue}📁 [dry-run] Would create output directory: $OUTPUT_DIR${Color_Off}"
  else
    echo -e "${Blue}📁 Creating output directory: $OUTPUT_DIR${Color_Off}"
    mkdir -p "$OUTPUT_DIR"
  fi
fi

image_exts=("jpg" "jpeg" "png" "tiff" "bmp" "webp" "heic" "gif")
video_exts=("mp4" "mov" "avi" "mkv" "webm" "3gp" "m4v" "flv")
text_exts=("txt")

img_renamed=0
img_converted=0
vid_renamed=0
vid_converted=0
gif_converted=0
txt_deleted=0
skipped=0
dupes_deleted=0

# Remove duplicates if required
if (( DEDUPLICATE )); then
  if ! command -v fdupes >/dev/null 2>&1; then
    echo "⚠️  fdupes is not installed. Please install it to enable duplicate removal."
  else
    if (( DRY_RUN )); then
      echo -e "${Red}🗑️  [dry-run] Would remove duplicate files with fdupes...${Color_Off}"
    else
      echo -e "${Red}🗑️  =>${Color_Off} Removing duplicate files with fdupes..."
      before=$(find . -maxdepth 1 -type f | wc -l | tr -d ' ')
      fdupes -dN . > /tmp/fdupes_log 2>&1
      after=$(find . -maxdepth 1 -type f | wc -l | tr -d ' ')
      ((dupes_deleted = before - after))
      if [[ $dupes_deleted -gt 0 ]]; then
        echo -e "${Red}🗑️  =>${Color_Off} $dupes_deleted duplicate file(s) deleted."
      else
        echo -e "${Green}✅ No duplicates found.${Color_Off}"
      fi
    fi
  fi
fi

debug "Looping over files in folder: $PWD"
for file in *; do
  if [[ -f "$file" ]]; then
    filename=$(basename "$file")
    extension="${filename##*.}"
    ext_lower="${extension:l}"
    # You can use your ran command or a random string generator here
    newname="$(ran)"

    debug "Processing file: '$file' (filename: $filename)"
    debug "Extension: $extension | ext_lower: $ext_lower"
    debug "PROCESS_IMAGES=$PROCESS_IMAGES PROCESS_VIDEOS=$PROCESS_VIDEOS"

    # Images
    if in_array "$ext_lower" "${image_exts[@]}" && (( PROCESS_IMAGES )); then
      debug "Recognized as IMAGE."
      case "$ext_lower" in
        jpg|jpeg)
          debug "Image is jpg/jpeg"
          if (( DRY_RUN )); then
            echo -e "${Green}🖼️  [dry-run] Would rename ${Blue}$file${Color_Off} to ${Green}$newname.jpg${Color_Off}"
          else
            echo -e "${Green}🖼️  =>${Color_Off} Renaming ${Blue}$file${Color_Off} to ${Green}$newname.jpg${Color_Off}"
            mv "$file" "$OUTPUT_DIR/$newname.jpg"
          fi
          ((img_renamed++))
          ;;
        png|tiff|bmp|webp|heic)
          debug "Image is $ext_lower (to be converted to jpg)"
          if (( DRY_RUN )); then
            echo -e "${Green}🖼️  [dry-run] Would convert ${Blue}$file${Color_Off} to ${Green}$newname.jpg${Color_Off}"
          else
            echo -e "${Green}🖼️  =>${Color_Off} Converting ${Blue}$file${Color_Off} to ${Green}$newname.jpg${Color_Off}"
            if magick "$file" "$OUTPUT_DIR/$newname.jpg"; then
              rm "$file"
            else
              echo -e "${Red}❌ Error converting $file${Color_Off}"
              ((skipped++))
            fi
          fi
          ((img_converted++))
          ;;
        gif)
          debug "Image is gif (to be converted to mp4)"
          if (( DRY_RUN )); then
            echo -e "${Green}🎞️  [dry-run] Would convert GIF ${Blue}$file${Color_Off} to ${Green}$newname.mp4${Color_Off}"
          else
            echo -e "${Green}🎞️  =>${Color_Off} Converting GIF ${Blue}$file${Color_Off} to ${Green}$newname.mp4${Color_Off}"
            if ffmpeg -y -i "$file" -movflags faststart -pix_fmt yuv420p -c:v libx264 -c:a aac "$OUTPUT_DIR/$newname.mp4"; then
              rm "$file"
            else
              echo -e "${Red}❌ Error converting $file${Color_Off}"
              ((skipped++))
            fi
          fi
          ((gif_converted++))
          ;;
      esac
    # Videos
    elif in_array "$ext_lower" "${video_exts[@]}" && (( PROCESS_VIDEOS )); then
      debug "Recognized as VIDEO."
      case "$ext_lower" in
        mp4)
          debug "Video is mp4"
          if (( DRY_RUN )); then
            echo -e "${Green}🎬 [dry-run] Would rename ${Blue}$file${Color_Off} to ${Green}$newname.mp4${Color_Off}"
          else
            echo -e "${Green}🎬 =>${Color_Off} Renaming ${Blue}$file${Color_Off} to ${Green}$newname.mp4${Color_Off}"
            mv "$file" "$OUTPUT_DIR/$newname.mp4"
          fi
          ((vid_renamed++))
          ;;
        mov|avi|mkv|webm|3gp|m4v|flv)
          debug "Video is $ext_lower (to be converted to mp4)"
          if (( DRY_RUN )); then
            echo -e "${Green}🎬 [dry-run] Would convert video ${Blue}$file${Color_Off} to ${Green}$newname.mp4${Color_Off}"
          else
            echo -e "${Green}🎬 =>${Color_Off} Converting video ${Blue}$file${Color_Off} to ${Green}$newname.mp4${Color_Off}"
            if ffmpeg -y -i "$file" -movflags faststart -pix_fmt yuv420p -c:v libx264 -c:a aac "$OUTPUT_DIR/$newname.mp4"; then
              rm "$file"
            else
              echo -e "${Red}❌ Error converting $file${Color_Off}"
              ((skipped++))
            fi
          fi
          ((vid_converted++))
          ;;
      esac
    # Text
    elif in_array "$ext_lower" "${text_exts[@]}"; then
      debug "Recognized as TXT."
      if (( DRY_RUN )); then
        echo -e "${Red}🗑️  [dry-run] Would remove text file ${Red}$file${Color_Off}"
      else
        echo -e "${Red}🗑️  =>${Color_Off} Removing text file ${Red}$file${Color_Off}"
        rm "$file"
      fi
      ((txt_deleted++))
    else
      debug "Unrecognized extension: $ext_lower (file: $file)"
      echo -e "${Yellow}⏭️  =>${Color_Off} Skipping unsupported file type: ${Yellow}$file${Color_Off}"
      ((skipped++))
    fi
  fi
done

# Summary
echo ""
echo -e "${Blue}====== SUMMARY ======${Color_Off}"
if (( DRY_RUN )); then
  echo -e "${Yellow}⚠️  DRY-RUN MODE: No files were changed.${Color_Off}"
fi
echo -e "🗑️  Duplicates deleted: ${Red}$dupes_deleted${Color_Off}"
echo -e "🖼️  Images renamed:     ${Green}$img_renamed${Color_Off}"
echo -e "🖼️  Images converted:   ${Green}$img_converted${Color_Off}"
echo -e "🎬  Videos renamed:     ${Green}$vid_renamed${Color_Off}"
echo -e "🎬  Videos converted:   ${Green}$vid_converted${Color_Off}"
echo -e "🎞️  GIFs converted:     ${Green}$gif_converted${Color_Off}"
echo -e "🗑️  Files deleted:      ${Red}$txt_deleted${Color_Off}"
echo -e "⏭️  Files skipped:      ${Yellow}$skipped${Color_Off}"
echo -e "${Blue}=====================${Color_Off}"

exit 0
