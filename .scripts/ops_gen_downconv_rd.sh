#!/usr/bin/env bash

if [[ "${#}" -ge 1 ]] ; then
    flac="${1}"
else
    flac="$(ls ./*flac | head -1)"
fi

if [[ -z "${flac}" ]] ; then
    echo "Error: no flacs found" >&2
    exit 1
fi

mediainfo_json="$(mediainfo --Output=JSON -- "${flac}")"

bit_depth="$(jq -r '.media.track[1].BitDepth' <<< "${mediainfo_json}")"
sampling_rate="$(jq -r '.media.track[1].SamplingRate' <<< "${mediainfo_json}")"

sampling_rate_dec="$(bc -l <<< "scale=1 ; ${sampling_rate}/1000")"

if [[ "${sampling_rate_dec}" == *.0 ]] ; then
    sampling_rate_dec="${sampling_rate_dec%.0}"
fi

source_specs="$(jq -r '.media.track[0].extra.SOURCE_SPECS' <<< "${mediainfo_json}")"

source_bitdepth="${source_specs%,*}"
source_sampling_rate="$(cut -d ' ' -f 3 <<< "${source_specs}")"
source_sampling_rate_dec="$(bc -l <<< "scale=1 ; ${source_sampling_rate}/1000")"

if [[ "${source_sampling_rate_dec}" == *.0 ]] ; then
    source_sampling_rate_dec="${source_sampling_rate_dec%.0}"
fi

sox_command="$(jq -r '.media.track[0].extra.SOX_COMMAND' <<< "${mediainfo_json}")"

cat << EOF
Downconverted from source (${source_bitdepth} ${source_sampling_rate_dec} KHz)
Encode Specifics: ${bit_depth} bit ${sampling_rate_dec} KHz
[b]Transcode process:[/b] [code]${sox_command}[/code]
EOF
