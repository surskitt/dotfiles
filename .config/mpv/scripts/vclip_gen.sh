#!/usr/bin/env bash

if [[ "${#}" -lt 3 ]]; then
    echo "Usage: ${0} {VID} {START} {END}" >&2
    exit 1
fi

VID="${1}"
START="${2}"
END="${3}"

if [[ "${START}" == "no" || "${END}" == "no" ]]; then
    echo "Error: start and end points not set" >&2
    exit 1
fi

STARTP="$(printf "%05d\n" "${START}")"
ENDP="$(printf "%05d\n" "${END}")"

FN="${VID}_${STARTP}_${ENDP}.vclip"

cat << EOF > "${FN}"
VID="${VID}"
START="${START}"
END="${END}"
EOF
