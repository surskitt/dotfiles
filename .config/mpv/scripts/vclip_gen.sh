#!/usr/bin/env bash

if [[ "${#}" -lt 3 ]]; then
    echo "Usage: ${0} {VID} {START} {END}" >&2
    exit 1
fi

VDIR="${1%/*}"
VID="${1##*/}"
START="${2}"
END="${3}"

if [[ "${4}" != "(empty)" ]]; then
    crop_vf="${4}"

    eval "$(grep -Po '\w=\d+' <<< "${crop_vf}")"

    CROP="${w}:${h}:${x}:${y}"
fi

mkdir "${VDIR}/clips"

if [[ "${START}" == "no" || "${END}" == "no" ]]; then
    echo "Error: start and end points not set" >&2
    exit 1
fi

STARTP="$(printf "%05d\n" "${START}")"
ENDP="$(printf "%05d\n" "${END}")"

if [[ "${crop_vf}" != "" ]]; then
    FN="${VDIR}/clips/${VID}_${STARTP}_${ENDP}_${CROP}.vclip"

    cat <<- EOF > "${FN}"
	VID="../${VID}"
	START="${START}"
	END="${END}"
	CROP="${CROP}"
	EOF
else
    FN="${VDIR}/clips/${VID}_${STARTP}_${ENDP}.vclip"

    cat <<- EOF > "${FN}"
	VID="../${VID}"
	START="${START}"
	END="${END}"
	EOF
fi
