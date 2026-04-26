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
    metaflac --show-tag="${1}" "${2}" | cut -d = -f 2 | tr '\n' '_' | sed 's/_/ _ /g;s#/#_#g;s/ _ $//'
}

artist="$(get_tag ARTIST "${firstflac}")"
album="$(get_tag ALBUM "${firstflac}")"
year="$(get_tag YEAR "${firstflac}")"
label="$(get_tag LABEL "${firstflac}")"
bitdepth="$(metaflac --show-bps "${firstflac}")"
samplingrate="$(metaflac --show-sample-rate "${firstflac}")"

version="$(get_tag VERSION "${firstflac}")"
if [[ -n "${version}" ]] ; then
    album="${album} (${version})"
fi

upc="$(get_tag UPC "${firstflac}")"

if [[ "${samplingrate}" == "44100" ]] ; then
    samplingrate="44.1"
else
    samplingrate="${samplingrate%000}"
fi

rddir="${rd%/*}"

if [[ "${rddir}" == "${rd}" ]] ; then
    rddir=.
fi

mv "${rd}" "${rddir}/-${artist} - ${album} (${year}) {${label}, ${upc}} [WEB FLAC ${bitdepth}-${samplingrate}]"
