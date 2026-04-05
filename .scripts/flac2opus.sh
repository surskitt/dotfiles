#!/usr/bin/env bash

DEST_DIR="/mnt/nfs/mallard/media/music"
SRC_DIR="${PWD}"

mapfile -d $'\0' flacs < <(find "${SRC_DIR}" -name '*.flac' -print0 | sort -z)

temp_dir="$(mktemp -d)"
trap 'rm -rf -- "${temp_dir}"' EXIT

echo "Transcoding ${#flacs[@]} flacs"

parallel --progress --unsafe opusenc --quiet --bitrate 160 "{}" "${temp_dir}"/"{/.}.opus" ::: "${flacs[@]}"
echo "${PWD##*/}" > "${temp_dir}"/source.txt

(
    cd "${temp_dir}"
    zsh
)

artist="$(opusinfo "${temp_dir}"/*.opus | grep '	ALBUMARTIST=' | cut -d '=' -f 2 | sort -u)"

if [[ "$(wc -l <<< "${artist}")" -gt 1 ]] ; then
    echo "Error: opus files have more than one album artist" >&2
    exit 1
fi

if [[ -z "${artist}" ]] ; then
    artist="$(opusinfo "${temp_dir}"/*.opus | grep '	ARTIST=' | cut -d '=' -f 2 | sort -u)"
fi

if [[ "$(wc -l <<< "${artist}")" -gt 1 ]] ; then
    echo "Error: opus files have more than one artist and no album artist" >&2
    exit 1
fi

if [[ -z "${artist}" ]] ; then
    echo "Error: opus files do not contain an artist" >&2
    exit 1
fi

album="$(opusinfo "${temp_dir}"/*.opus | grep '	ALBUM=' | cut -d '=' -f 2 | sort -u)"

if [[ "$(wc -l <<< "${album}")" -gt 1 ]] ; then
    echo "Error: opus files have more than one album" >&2
    exit 1
fi

if [[ -z "${album}" ]] ; then
    echo "Error: opus files do not contain an album" >&2
    exit 1
fi

dest_subdir="${DEST_DIR}/${artist}/${album}"
mkdir -p "${dest_subdir}"

echo "Moving transcoded opus files to ${dest_subdir}"
mv "${temp_dir}"/* "${dest_subdir}"

find "${SRC_DIR}" \! -name '*.flac' \! -name '*.m3u' \! -name '*.m3u8' -type f | while read -r f ; do
    src_fn="${f##"${SRC_DIR}/"}"
    src_fn="${src_fn//\//_}"

    dest_path="${dest_subdir}/${src_fn}"

    echo "${f}"
    echo "->"
    echo "${dest_path}"

    cp "${f}" "${dest_path}"

    echo
done
