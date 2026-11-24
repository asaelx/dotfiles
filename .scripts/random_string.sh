#!/usr/bin/env bash

fail() {
  printf 'ran: %s\n' "$*" >&2
  exit 1
}

# Use ASCII ranges consistently when filtering and checking characters.
export LC_ALL=C

(( $# <= 1 )) || fail 'Usage: ran [length]'
length=${1-13}
[[ $length =~ ^[0-9]+$ ]] || fail 'Length must be a whole number of at least 3.'
length=${length#"${length%%[!0]*}"}
[[ -n $length ]] || fail 'Length must be at least 3.'
number=$((10#$length))
[[ $number == "$length" && $number -ge 3 ]] || fail 'Length is out of range (minimum 3).'

command -v openssl >/dev/null 2>&1 || fail 'openssl is required.'
command -v tr >/dev/null 2>&1 || fail 'tr is required.'

batch_size=$number
(( batch_size >= 48 )) || batch_size=48
(( batch_size <= 4096 )) || batch_size=4096

while :; do
  candidate=
  while (( ${#candidate} < number )); do
    random_bytes=$(openssl rand -base64 "$batch_size") || fail 'Could not generate random bytes.'
    characters=$(printf '%s' "$random_bytes" | tr -dc 'A-Za-z0-9') || fail 'Could not filter random characters.'
    [[ -n $characters ]] || fail 'No random characters were generated.'
    candidate=$candidate$characters
  done

  candidate=${candidate:0:number}
  # Retry with a fresh candidate if any required character group is missing.
  if [[ $candidate == *[A-Z]* && $candidate == *[a-z]* && $candidate == *[0-9]* ]]; then
    printf '%s\n' "$candidate"
    exit $?
  fi
done
