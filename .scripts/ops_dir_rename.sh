#!/usr/bin/env bash

rd="${1}"

if [[ -z "${rd}" || ! -d "${rd}" ]] ; then
    echo "Error: pass a dir as the first argument" >&2
    exit 1
fi

firstflac="$(find "${rd}"/*.flac 2>/dev/null | head -1)"

if [[ -z "${firstflac}" ]] ; then
    echo "No flacs found in current dir" >&2
    exit 1
fi

get_tag() {
    metaflac --show-tag="${1}" "${2}" | cut -d = -f 2
}

json="$(mediainfo --Output=JSON "${firstflac}")"

artist="$(jq -r '.media.track[0].Album_Performer' <<< "${json}" | sed 's#/#_#g')"
album="$(jq -r '.media.track[0].Album' <<< "${json}" | sed 's#/#_#g')"
recorded_date="$(jq -r '.media.track[0].Recorded_Date' <<< "${json}" | cut -d '/' -f 2 | xargs)"
year="${recorded_date%%-*}"
label="$(jq -r '.media.track[0].Label' <<< "${json}" | sed 's#/#_#g')"
bitdepth="$(jq -r '.media.track[1].BitDepth' <<< "${json}")"
samplingrate="$(jq -r '.media.track[1].SamplingRate' <<< "${json}")"

album_more="$(jq -r '.media.track[0].Title_More' <<< "${json}" | sed 's#/#_#g')"
if [[ "${album_more}" != null ]] ; then
    album="${album} (${album_more})"
fi

# upc="$(jq -r '.media.track[0].extra.upc' <<< "${json}" | sed 's#/#_#g')"
# upc="$(metaflac --show-tag=UPC "${firstflac}" | cut -d = -f 2)"
upc="$(get_tag UPC "${firstflac}")"

if [[ "${upc}" == "null" ]] ;  then
    upc="$(jq -r '.media.track[0].extra.CATALOGNUMBER' <<< "${json}" | sed 's#/#_#g')"
fi

if [[ "${samplingrate}" == "44100" ]] ; then
    samplingrate="44.1"
else
    samplingrate="${samplingrate%000}"
fi

rddir="${rd%/*}"

if [[ "${rddir}" == "${rd}" ]] ; then
    rddir=.
fi

# echo "${rddir}/${artist} - ${album} (${year}) {${label}, ${upc}} [WEB FLAC ${bitdepth}-${samplingrate}]"
mv "${rd}" "${rddir}/-${artist} - ${album} (${year}) {${label}, ${upc}} [WEB FLAC ${bitdepth}-${samplingrate}]"
