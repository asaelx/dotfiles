#!/usr/bin/env zsh
set -u
setopt pipefail
setopt extendedglob

Color_Off='\033[0m'
Green='\033[0;32m'
Blue='\033[0;34m'
Red='\033[0;31m'
Yellow='\033[1;33m'

EMOJI_OK="✅"
EMOJI_WARN="⚠️"
EMOJI_MOVE="📁"
EMOJI_IMG="🖼️"
EMOJI_VID="🎬"
EMOJI_DUP="♻️"
EMOJI_FOLDER="📂"
EMOJI_DONE="🎉"

# Keep extensions lowercase. We'll lowercase the detected extension before comparing.
IMG_EXTS=(jpg jpeg png heic webp bmp gif tiff tif)
VID_EXTS=(mp4 mov avi mkv webm 3gp m4v flv)

SRC="${HOME}/Downloads"
DEST="${HOME}/Pictures/Insta"
LOG="${TMPDIR:-/tmp}/insta_archiver_errors.log"

count_imgs=0
count_vids=0
typeset -A folders_actually_created

VERBOSE=0
MODE="all"
DRYRUN=0

show_help() {
cat << EOF2
$EMOJI_FOLDER Insta Archiver CLI Tool
Options:
  -i        Images only
  -v        Videos only
  -s DIR    Source folder (default: \$HOME/Downloads)
  -o DIR    Destination folder (default: \$HOME/Pictures/Insta)
  -d        Dry-run (simulate only, don't move)
  -V        Verbose/debug mode
  -h        Show this help

Notes:
  - Files are moved into subfolders named after the detected username.
  - Duplicates are removed with fdupes (recursive). Summary reports duplicate FILES removed.
EOF2
exit 0
}

log_debug() { if [[ $VERBOSE -eq 1 ]]; then echo "DEBUG: $1"; fi }
log_error() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $1" >> "$LOG"; }
log_info()  { echo "[$(date '+%Y-%m-%d %H:%M:%S')] INFO:  $1" >> "$LOG"; }

ensure_dest() {
    if [[ -d "$DEST" ]]; then
        echo "$EMOJI_OK Destination folder exists: $DEST"
        return
    fi
    echo -e "${Blue}${EMOJI_FOLDER} Creating destination folder:${Color_Off} ${Green}$DEST${Color_Off}"
    mkdir -p "$DEST" || { log_error "Error creating $DEST"; exit 1; }
}

# Replace any characters not safe for folder names with underscores.
sanitize_username() {
    local raw="$1"
    local safe

    # Trim surrounding whitespace
    raw="${raw##[[:space:]]#}"
    raw="${raw%%[[:space:]]#}"

    # Replace any unsafe characters
    safe="${raw//[^A-Za-z0-9._-]/_}"

    # Collapse repeated underscores
    while [[ "$safe" == *"__"* ]]; do
        safe="${safe//__/_}"
    done

    # Trim leading/trailing underscores
    safe="${safe##(_)#}"
    safe="${safe%%(_)#}"

    [[ -z "$safe" ]] && safe="unknown"
    echo "$safe"
}

build_find_pattern() {
    local arr=()
    if [[ "$1" == "img" ]]; then
        arr=(${IMG_EXTS[@]})
    elif [[ "$1" == "vid" ]]; then
        arr=(${VID_EXTS[@]})
    else
        arr=(${IMG_EXTS[@]} ${VID_EXTS[@]})
    fi

    local pat=()
    local ext
    for ext in "${arr[@]}"; do
        pat+=(-iname "*.${ext}")
        pat+=(-o)
    done
    unset "pat[${#pat[@]}]"  # remove trailing -o
    echo "${pat[@]}"
}

# Lowercase helper (zsh supports the :l modifier).
lowercase() {
    echo "${1:l}"
}

while getopts ":ivds:o:Vh" opt; do
    case $opt in
        i) MODE="img";;
        v) MODE="vid";;
        s) SRC="$OPTARG";;
        o) DEST="$OPTARG";;
        d) DRYRUN=1;;
        V) VERBOSE=1;;
        h) show_help;;
        \?) echo "$EMOJI_WARN Invalid option: -$OPTARG" >&2; show_help;;
    esac
done

echo "[$(date '+%Y-%m-%d %H:%M:%S')] ===== Run started =====" >> "$LOG"
echo "$EMOJI_OK Starting Insta Archiver CLI"
echo "Shell: $SHELL $ZSH_VERSION"
echo "Source folder: $SRC"
echo "Destination folder: $DEST"
echo "Mode: $MODE"
echo "Dry run: $DRYRUN"
echo "Verbose: $VERBOSE"
echo "Supported images: ${IMG_EXTS[@]}"
echo "Supported videos: ${VID_EXTS[@]}"
echo ""

ensure_dest

PATTERN=($(build_find_pattern "$MODE"))
echo "$EMOJI_OK Using find pattern: ${PATTERN[@]}"
echo ""

# Avoid zsh glob errors when patterns don't match.
unsetopt nomatch

files=()
while IFS= read -r -d $'\0' file; do
    files+=("$file")
done < <(find "$SRC" -maxdepth 1 -type f \( "${PATTERN[@]}" \) -print0)

log_debug "Files found: ${#files[@]}"
if [[ ${#files[@]} -eq 0 ]]; then
    echo "$EMOJI_WARN No files in $SRC"
    exit 0
fi

echo "$EMOJI_OK Found ${#files[@]} files to process in $SRC"
echo "$EMOJI_OK Processing files..."
echo ""

for file in "${files[@]}"; do
    fname="${file##*/}"
    ext="${fname##*.}"
    ext_lc="$(lowercase "$ext")"

    # Username: everything before the first _[number] where number has at least 7 digits (Instagram style)
    username=$(perl -pe 's/^(.+?)(?=_[0-9]{7,}(_|\.|$)).*/\1/' <<< "$fname")

    if [[ -z "$username" || "$username" == "$fname" ]]; then
        if [[ "$fname" == *_* ]]; then
            username="${fname%%_*}"
        else
            username="unknown"
        fi
    fi
    [[ -z "$username" ]] && username="unknown"

    username="$(sanitize_username "$username")"

    dest_folder="$DEST/$username"
    if [[ ! -d "$dest_folder" && -z "${folders_actually_created[$username]:-}" ]]; then
        echo -e "${Blue}${EMOJI_FOLDER} Creating folder:${Color_Off} ${Green}${dest_folder}${Color_Off}"
        if (( DRYRUN )); then
            folders_actually_created[$username]=1
        else
            if mkdir -p "$dest_folder" 2>>"$LOG"; then
                folders_actually_created[$username]=1
            else
                log_error "Error creating $dest_folder"
                echo -e "${EMOJI_WARN} ${Red}Error creating folder $dest_folder (see log)${Color_Off}"
                continue
            fi
        fi
    fi

    is_img=0
    is_vid=0
    for e in "${IMG_EXTS[@]}"; do [[ "$ext_lc" == "$e" ]] && is_img=1; done
    for e in "${VID_EXTS[@]}"; do [[ "$ext_lc" == "$e" ]] && is_vid=1; done

    (( is_img )) && ((count_imgs++))
    (( is_vid )) && ((count_vids++))

    emoji="$EMOJI_MOVE"
    [[ $is_img -eq 1 ]] && emoji="$EMOJI_IMG"
    [[ $is_vid -eq 1 ]] && emoji="$EMOJI_VID"

    echo -e "${emoji} ${Blue}${fname}${Color_Off} => ${Green}${dest_folder}/${Color_Off}"
    log_debug "mv \"$file\" \"$dest_folder/\""

    (( DRYRUN )) && continue

    if [[ -e "$dest_folder/$fname" ]]; then
        log_error "Skipped $fname — already exists in $dest_folder"
        echo -e "${EMOJI_WARN} ${Yellow}Skipped ${Blue}$fname${Yellow} (already exists in destination)${Color_Off}"
        (( is_img )) && ((count_imgs--))
        (( is_vid )) && ((count_vids--))
        continue
    fi

    if ! mv "$file" "$dest_folder/" 2>>"$LOG"; then
        log_error "Error moving $fname"
        echo -e "${EMOJI_WARN} ${Red}Error moving $fname (see log)${Color_Off}"
    else
        log_info "Moved $fname -> $dest_folder/"
        echo -e "${EMOJI_OK} Moved ${Blue}$fname${Color_Off} to ${Green}${dest_folder}/${Color_Off}"
    fi
done

# Duplicates: count before and after (duplicate FILES, not sets)
dup_files_removed=0
if ! command -v fdupes >/dev/null 2>&1; then
    echo "$EMOJI_WARN fdupes is not installed. Duplicates will not be deleted." | tee -a "$LOG"
else
    echo "$EMOJI_OK Searching for duplicates with fdupes in $DEST (recursive)..."

    if (( DRYRUN )); then
        # In dry-run, just report what would be removed: sum of (group_size - 1) for each group.
        dup_files_removed=$(fdupes -r "$DEST" 2>>"$LOG" | awk '
            /^$/ { if (n > 0) { total += n-1; n=0 } next }
            { n++ }
            END { if (n > 0) total += n-1; print total+0 }
        ')
    else
        # --summarize reports "X duplicate files (in Y sets)" — extract the leading number.
        summary=$(fdupes -r -N -d --summarize "$DEST" 2>>"$LOG")
        log_info "fdupes summary: $summary"
        dup_files_removed=$(echo "$summary" | grep -o '^[0-9]*' || echo 0)
        dup_files_removed=${dup_files_removed:-0}
    fi

    if (( dup_files_removed > 0 )); then
        log_info "Removed $dup_files_removed duplicate files."
        echo "$EMOJI_DUP Removed $dup_files_removed duplicate files."
    else
        echo "$EMOJI_DUP No duplicate files removed."
    fi
fi

folders_created=${#folders_actually_created[@]}

echo ""
echo "---------- $EMOJI_DONE SUMMARY ----------"
echo "$EMOJI_IMG  Images moved: $count_imgs"
echo "$EMOJI_VID  Videos moved: $count_vids"
echo "$EMOJI_DUP  Duplicate files removed: $dup_files_removed"
echo "$EMOJI_FOLDER Folders created: $folders_created"
