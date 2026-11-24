#!/usr/bin/env bash

usage() {
  cat <<'HELP'
Usage: rim [-i | -v] [-dng] [-o directory] [--remove-originals]

Rename media in the current directory using random 13-character names.
JPEG and MP4 files are renamed. Other supported formats are converted.

  -i                  Process images only (including GIF)
  -v                  Process videos only
  -d                  Remove byte-identical duplicates among selected media
  -n                  Preview actions without changing files
  -g                  Print debugging details
  -o directory        Write output to this directory (default: current directory)
  --remove-originals  Remove source files after successful conversion
  -h                  Show this help

Images: jpg, jpeg, png, tiff, bmp, webp, heic, gif
Videos: mp4, mov, avi, mkv, webm, 3gp, m4v, flv
HELP
}

error() {
  printf 'rim: %s\n' "$*" >&2
}

fail() {
  error "$@"
  exit 1
}

debug() {
  if (( debug_enabled )); then printf 'rim: %s\n' "$*" >&2; fi
}

mode=all
deduplicate=0
dry_run=0
debug_enabled=0
remove_originals=0
output_dir=.

while getopts ':ivdngo:h-:' opt; do
  case "$opt" in
    i) mode=images ;;
    v) mode=videos ;;
    d) deduplicate=1 ;;
    n) dry_run=1 ;;
    g) debug_enabled=1 ;;
    o) output_dir=$OPTARG ;;
    h) usage; exit 0 ;;
    -) case "$OPTARG" in
         remove-originals) remove_originals=1 ;;
         *) fail "Unknown option: --$OPTARG" ;;
       esac ;;
    :) fail "Option -$OPTARG requires an argument." ;;
    \?) fail "Unknown option: -$OPTARG" ;;
  esac
done
shift "$((OPTIND - 1))"
(( $# == 0 )) || fail "Unexpected argument: $1"
[[ -n $output_dir ]] || fail 'Output directory cannot be empty.'
[[ $output_dir == /* ]] || output_dir="./$output_dir"

script=${BASH_SOURCE[0]}
# Follow symlinks without relying on GNU readlink -f.
while [[ -L $script ]]; do
  link=$(readlink "$script") || fail "Cannot resolve $script"
  case "$link" in
    /*) script=$link ;;
    *) script="$(dirname "$script")/$link" ;;
  esac
done
generator="$(dirname "$script")/random_string.sh"

files=()
actions=()
extensions=()
export LC_ALL=C
shopt -s nullglob nocasematch
for file in ./*; do
  [[ -f $file && ! -L $file && ${file##*/} == *.* ]] || continue
  case "${file##*.}" in
    jpg|jpeg)           group=images; action=rename; extension=jpg ;;
    png|tiff|bmp|webp|heic) group=images; action=magick; extension=jpg ;;
    gif)                group=images; action=ffmpeg; extension=mp4 ;;
    mp4)                group=videos; action=rename; extension=mp4 ;;
    mov|avi|mkv|webm|3gp|m4v|flv) group=videos; action=ffmpeg; extension=mp4 ;;
    *) continue ;;
  esac
  [[ $mode == all || $mode == "$group" ]] || continue
  files+=("$file")
  actions+=("$action")
  extensions+=("$extension")
done
shopt -u nocasematch

renamed=0
converted=0
duplicates=0
failed=0
temp_dir=

cleanup() {
  if [[ -n $temp_dir ]]; then
    rm -rf "$temp_dir" || return 1
    temp_dir=
  fi
}
trap cleanup EXIT
trap 'exit 129' HUP
trap 'exit 130' INT
trap 'exit 143' TERM

remove_duplicates() {
  local i id file
  # Give fdupes only selected files and use numeric names for unambiguous output.
  temp_dir=$(mktemp -d ./.rim-duplicates.XXXXXXXX) || return 1
  mkdir "$temp_dir/files" || return 1
  for i in "${!files[@]}"; do
    ln "${files[i]}" "$temp_dir/files/$i" || return 1
  done
  fdupes -q -f "$temp_dir/files" > "$temp_dir/results" || return 1
  while IFS= read -r id; do
    [[ -n $id ]] || continue
    id=${id##*/}
    [[ $id =~ ^(0|[1-9][0-9]*)$ && -n ${files[id]} ]] || return 1
    file=${files[id]}
    [[ ! -L $file && $file -ef $temp_dir/files/$id ]] || return 1
    rm "$file" || return 1
    printf 'Removed duplicate %q\n' "$file"
    unset 'files[id]'
    (( duplicates += 1 ))
  done < "$temp_dir/results"
  cleanup
}

choose_destination() {
  local attempt name
  for ((attempt = 0; attempt < 20; attempt++)); do
    name=$("$generator") || return 1
    [[ $name =~ ^[A-Za-z0-9]{13}$ ]] || return 1
    output_name="$name.$1"
    target="$output_dir/$output_name"
    [[ -e $target || -L $target ]] || return 0
    debug "Destination exists, retrying: $target"
  done
  return 1
}

process_file() {
  local file=$1 action=$2 extension=$3 output_name target
  choose_destination "$extension" || { error 'Could not generate an available filename.'; return 1; }

  if (( dry_run )); then
    case "$action" in
      rename) printf 'Would rename %q to %q\n' "$file" "$target" ;;
      *) printf 'Would convert %q to %q\n' "$file" "$target"
         if (( remove_originals )); then printf 'Would then remove %q\n' "$file"; fi ;;
    esac
    return 0
  fi

  if [[ $action == rename ]]; then
    mv -n "$file" "$target" && [[ ! -e $file && ! -L $file && -f $target ]] || return 1
    (( renamed += 1 ))
    printf 'Renamed %q to %q\n' "$file" "$target"
    return
  fi

  command -v "$action" >/dev/null 2>&1 || { error "$action is required to convert this file."; return 1; }
  temp_dir=$(mktemp -d "$output_dir/.rim-convert.XXXXXXXX") || return 1
  case "$action" in
    magick) magick "$file" -adjoin "$temp_dir/$output_name" || return 1 ;;
    ffmpeg) ffmpeg -nostdin -n -i "$file" -movflags faststart -pix_fmt yuv420p \
              -c:v libx264 -c:a aac "$temp_dir/$output_name" || return 1 ;;
  esac
  # Publish on the same filesystem and verify that a collision did not skip the move.
  local temporary_output="$temp_dir/$output_name"
  [[ -s $temporary_output ]] && mv -n "$temporary_output" "$output_dir/" &&
    [[ ! -e $temporary_output && -f $target ]] || return 1
  (( converted += 1 ))
  printf 'Converted %q to %q\n' "$file" "$target"
  if (( remove_originals )); then rm "$file" || return 1; fi
}

debug "Mode=$mode dry_run=$dry_run output_dir=$output_dir"
if (( deduplicate && ${#files[@]} > 1 )); then
  command -v fdupes >/dev/null 2>&1 || fail 'fdupes is required for -d.'
  if (( dry_run )); then
    printf 'Would check selected media for duplicates before processing. Preview includes all candidates.\n'
  else
    remove_duplicates || fail 'Duplicate removal failed.'
  fi
fi

if (( ${#files[@]} > 0 )) && [[ ! -d $output_dir ]]; then
  if (( dry_run )); then
    printf 'Would create directory %q\n' "$output_dir"
  else
    mkdir -p "$output_dir" || fail "Cannot create output directory: $output_dir"
  fi
fi

for i in "${!files[@]}"; do
  if ! process_file "${files[i]}" "${actions[i]}" "${extensions[i]}"; then
    error "Failed to process ${files[i]}"
    (( failed += 1 ))
  fi
  cleanup || fail 'Could not remove temporary files.'
done

if (( dry_run )); then
  printf 'Dry run complete. Files previewed: %d. Failed: %d.\n' "${#files[@]}" "$failed"
else
  printf 'Renamed: %d. Converted: %d. Duplicates removed: %d. Failed: %d.\n' \
    "$renamed" "$converted" "$duplicates" "$failed"
fi
(( failed == 0 ))
