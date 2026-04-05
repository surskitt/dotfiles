#!/usr/bin/env bash

printclear() {
    echo -e "\e[1A\e[K${1}"
}

TEMPDIR="$(mktemp -d)"
trap 'rm -rf -- "${TEMPDIR}"' EXIT

arg_current=0
arg_count="${#}"

echo

for i in "${@}" ; do
    arg_current="$((arg_current+1))"

    printclear "generating spec for ${i} (${arg_current}/${arg_count})"

    INPUT_FLAC="${i}"
    OUTPUT_FN="${i//\//_}"
    FILENAME_NO_EXT="${OUTPUT_FN%.flac}"
    FULL_SPECTRAL="${TEMPDIR}/${FILENAME_NO_EXT}.png"
    ZOOM_SPECTRAL="${TEMPDIR}/${FILENAME_NO_EXT}_zoom.png"

    duration="$(mediainfo --Output=JSON -- "${INPUT_FLAC}" | jq -r '.media.track[1].Duration')"
    duration="${duration%.*}"
    zoom_startpoint="$((duration/2))"

    sox \
        --multi-threaded "${INPUT_FLAC}" \
        --buffer 128000 \
        -n remix 1 spectrogram \
        -x 2000 \
        -y 513 \
        -z 120 \
        -w Kaiser \
        -t "${i}" \
        -o "${FULL_SPECTRAL}" \
        remix 1 spectrogram \
        -x 500 \
        -y 1025 \
        -z 120 \
        -w Kaiser \
        -t "${i}" \
        -S "${zoom_startpoint}" \
        -d 0:02 \
        -o "${ZOOM_SPECTRAL}"
done

imv "${TEMPDIR}"
