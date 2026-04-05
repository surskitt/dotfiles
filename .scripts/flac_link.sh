#!/usr/bin/env bash

SRC_DIR="${PWD}"
DEST_DIR="/mnt/nfs/mallard/media/music"

mapfile -d $'\0' flacs < <(find "${SRC_DIR}" -name '*.flac' -print0 | sort -z)

if [[ "${#flacs[@]}" -eq 0 ]] ; then
    echo "Error: no flacs found" >&2
    exit 1
fi

artist="$(metaflac --show-tag=albumartist "${flacs[@]}" | rev | cut -d '=' -f 1 | rev | sort -u)"
artist="${artist/\//_}"

if [[ "$(wc -l <<< "${artist}")" -gt 1 ]] ; then
    echo "Error: flacs have more than one album artist" >&2
    exit 1
fi

if [[ -z "${artist}" ]] ; then
    artist="$(metaflac --show-tag=artist "${flacs[@]}" | rev | cut -d '=' -f 1 | rev | sort -u)"
fi

if [[ "$(wc -l <<< "${artist}")" -gt 1 ]] ; then
    echo "Error: flacs have more than one artist and no album artist" >&2
    exit 1
fi

if [[ -z "${artist}" ]] ; then
    echo "Error: flacs do not contain an artist" >&2
    exit 1
fi

album="$(metaflac --show-tag=album "${flacs[@]}" | rev | cut -d '=' -f 1 | rev | sort -u)"
album="${album/\//_}"

if [[ "$(wc -l <<< "${album}")" -gt 1 ]] ; then
    echo "Error: flacs have more than one album" >&2
    exit 1
fi

if [[ -z "${album}" ]] ; then
    echo "Error: flacs do not contain an album" >&2
    exit 1
fi

discs="$(metaflac --show-tag=discnumber "${flacs[@]}" | rev | cut -d '=' -f 1 | rev | sort -u)"

dest_subdir="${DEST_DIR}/${artist}/${album}"
echo "Linking ${#flacs[@]} flacs to ${dest_subdir}"
mkdir -p "${dest_subdir}"

for flac in "${flacs[@]}" ; do
    trackno="$(metaflac --show-tag=tracknumber "${flac}" | rev | cut -d '=' -f 1 | rev)"
    title="$(metaflac --show-tag=title "${flac}" | rev | cut -d '=' -f 1 | rev)"

    printf -v trackno "%02d" "${trackno#0}"

    dest_fn="${trackno} - ${title}.flac"

    if [[ "$(wc -l <<< "${discs}")" -gt 1 ]] ; then
        disc="$(metaflac --show-tag=discnumber "${flac}" | rev | cut -d '=' -f 1 | rev)"
        dest_fn="${disc}.${dest_fn}"
    fi

    dest_path="${dest_subdir}/${dest_fn}"

    echo "${flac}"
    echo "->"
    echo "${dest_path}"

    ln "${flac}" "${dest_path}"

    echo
done

find "${SRC_DIR}" \! -name '*.flac' \! -name '*.m3u' \! -name '*.m3u8' -type f | while read -r f ; do
    src_fn="${f##"${SRC_DIR}/"}"
    src_fn="${src_fn//\//_}"

    dest_path="${dest_subdir}/${src_fn}"

    echo "${f}"
    echo "->"
    echo "${dest_path}"

    ln "${f}" "${dest_path}"

    echo
done
