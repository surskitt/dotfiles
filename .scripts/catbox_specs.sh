#!/usr/bin/env bash

tempdir="$(mktemp -d)"
trap 'rm -rf -- "${tempdir}"' EXIT

# api_key = subprocess.run(["gopass", "ra_api_key"], capture_output=True, encoding="utf-8").stdout.strip()
# api_key="$(gopass ra_api_key)"
catbox_user_hash="$(gopass catbox_user_hash)"

echo -n "[hide=Spectrals][b]"

for i in *.flac ; do 
    echo "[b]${i##*/} Full[/b]"

    input_flac="${i}"
    output_fn="${i//\//_}"
    filename_no_ext="${output_fn%.flac}"
    full_spectral="${tempdir}/${filename_no_ext}.png"
    zoom_spectral="${tempdir}/${filename_no_ext}_zoom.png"

    duration="$(mediainfo --Output=JSON -- "${input_flac}" | jq -r '.media.track[1].Duration')"
    duration="${duration%.*}"
    zoom_startpoint="$((duration/2))"

    sox \
        --multi-threaded "${input_flac}" \
        --buffer 128000 \
        -n remix 1 spectrogram \
        -x 2000 \
        -y 513 \
        -z 120 \
        -w Kaiser \
        -t "${i}" \
        -o "${full_spectral}" \
        remix 1 spectrogram \
        -x 500 \
        -y 1025 \
        -z 120 \
        -w Kaiser \
        -t "${i}" \
        -S "${zoom_startpoint}" \
        -d 0:02 \
        -o "${zoom_spectral}"

    # full="$(curl -s -L -X POST https://thesungod.xyz/api/image/upload -F "api_key=${api_key}" -F "image=@${full_spectral}")"
    full="$(catbox upload -u "${catbox_user_hash}" "${full_spectral}")"

    echo "[img=${full}]"

    # zoomed="$(curl -s -L -X POST https://thesungod.xyz/api/image/upload -F "api_key=${api_key}" -F "image=@${zoom_spectral}")"

    zoomed="$(catbox upload -u "${catbox_user_hash}" "${zoom_spectral}")"

    echo "[hide=Zoomed][img=${zoomed}][/hide]"

    echo
done

echo "[/hide]"
