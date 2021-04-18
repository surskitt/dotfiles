#!/usr/bin/env bash

CLIP_FILE="${1}"
CMD="${2:-play}"

if [ ! -f "${CLIP_FILE}" ]; then
    echo "Error: ${CLIP_FILE} does not exist" >&2
    exit 1
fi

# shellcheck disable=SC1090
source "${CLIP_FILE}"
# shellcheck disable=SC2164
cd "$(dirname "${CLIP_FILE}")"

for e in VID START END; do
    if [[ -z "${!e}" ]]; then
        echo "Error: ${e} is unset" >&2
        exit 1
    fi
done

# if [[ -n "${CROP}" ]]; then
#     CROP_ARG=("--vf='crop=${CROP}'")
# fi

case "${CMD}" in
    play)
        if [[ -n "${CROP}" ]]; then
            mpv --start="${START}" --ab-loop-a="${START}" --ab-loop-b="${END}" --vf="crop=${CROP}" "${VID}"
        else
            mpv --start="${START}" --ab-loop-a="${START}" --ab-loop-b="${END}" "${VID}"
        fi
        ;;
    thumb)
        OUTPUT_DIR="$(dirname "${CLIP_FILE}")/.thumbs"
        mkdir -p "${OUTPUT_DIR}"

        sum="$(echo -n "${CLIP_FILE}"|sha1sum|cut -d ' ' -f -1)"
        THUMB_FILE="${OUTPUT_DIR}/${sum}.png"

        if [[ "${START}" != *:* ]]; then
            TOTAL_SECONDS="${START%%.*}"
            HOURS="$(( TOTAL_SECONDS / 3600 ))"
            MINUTES="$(( (TOTAL_SECONDS % 3600) / 60 ))"
            SECONDS="$(( (TOTAL_SECONDS % 3600) % 60 ))"

            MINUTESP="$(printf "%02d\n" ${MINUTES})"
            SECONDSP="$(printf "%02d\n" ${SECONDS})"

            START="${HOURS}:${MINUTESP}:${SECONDSP}"
        fi

        ffmpegthumbnailer -i "${VID}" -o "${THUMB_FILE}" -s 0 -t "${START}"
        echo "${THUMB_FILE}"
        ;;
    *)
        echo "${CMD} is not a valid command" >&2
        exit 1
esac
