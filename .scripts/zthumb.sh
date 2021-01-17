#!/usr/bin/env bash

# OUTPUT_DIR=~/.thumbnails/zips

VERBOSE=false
while getopts 'vo:h' opt; do
  case "$opt" in
    o)
      OUTPUT_DIR="${OPTARG}"
      ;;
    v)
      VERBOSE=true
      ;;
    h)
      usage
      exit
      ;;
    ?)
      usage
      exit 1
      ;;
  esac
done
shift $(( OPTIND - 1 ))

OUTPUT_DIR="$(dirname "${1}")/.thumbs"
mkdir -p "${OUTPUT_DIR}"

FN="$(basename "${1}")"

zsum=$(echo -n "${FN}"|sha1sum|cut -d ' ' -f 1)

[ -f "${OUTPUT_DIR}/${zsum}.jpg" ] || {
    # thumb_file="$(unzip -Z1 "${1}"|egrep 'jpg|png'|sort|head -1)"
    # unzip -o "${1}" -d /tmp "${thumb_file/\[/\\[}"
    # mv "/tmp/${thumb_file}" "${OUTPUT_DIR}/${zsum}"
    # unzip -p -q "${1}" "${thumb_file//\[/\\[}" > "${OUTPUT_DIR}/${zsum}"
    comicthumb "${1}" "${OUTPUT_DIR}/${zsum}.jpg" 512
}

$VERBOSE && echo "${OUTPUT_DIR}/${zsum}.jpg"
