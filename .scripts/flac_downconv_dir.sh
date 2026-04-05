#!/usr/bin/env bash

if [[ "${#}" -lt 1 ]] ; then
    echo "Usage: ${0} dir1 dir2" >&2
    exit 1
fi

if [[ ! -d "${1}" ]] ; then
    echo "Error: arg must be a directory" >&2
    exit 1
fi

src_dir="$(realpath "${1}")"

if [[ "${src_dir}" != *'[WEB FLAC 24-'*']' ]] ; then
    echo "Error: source dir is not in expected format" >&2
    exit 1
fi

dest_dir="${src_dir/[WEB FLAC 24-/[WEB FLAC 16-}"

mkdir -p "${dest_dir}"

temp_dir="$(mktemp -d)"

for i in "${src_dir}"/* ; do
    echo "=== ${i}"

    fn="${i##*/}"
    dest_file="${dest_dir}/${fn}"

    if [[ -f "${dest_file}" ]] ; then
        echo "destination file already exists"
        continue
    fi

    if [[ "${i}" != *.flac ]] ; then
        echo "non flac file, copying"
        cp "${i}" "${dest_dir}"
        continue
    fi

    json="$(mediainfo --Output=JSON "${i}")"

    bit_depth="$(jq -r '.media.track[1].BitDepth' <<< "${json}")"

    if [[ "${bit_depth}" == 16 ]] ; then
        echo "16 bit flac, copying"
        cp "${i}" "${dest_dir}"
        continue
    fi

    sampling_rate="$(jq -r '.media.track[1].SamplingRate' <<< "${json}")"

    if [[ "${sampling_rate}" != "44100" ]] ; then
        sampling_rate="48000"
    fi

    echo "downconverting to 16 bit ${sampling_rate} KHz flac"
    sox "${i}" -G -b 16 "${dest_file}" rate -v -L "${sampling_rate}" dither

    echo "transferring metadata"
    metaflac --no-utf8-convert --export-tags-to=- "${i}" | \
        metaflac --remove-all-tags --import-tags-from=- "${dest_file}"

    echo "transferring art"
    art_file="${temp_dir}/${fn}.png"
    metaflac --export-picture-to="${art_file}" "${i}"
    metaflac --import-picture-from="${art_file}" "${dest_file}"
done
