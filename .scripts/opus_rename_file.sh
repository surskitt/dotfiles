#!/usr/bin/env bash

discs="$(for i in "${PWD}"/*.opus ; do opustags "${i}" | grep -E '^DISCNUMBER=' | cut -d '=' -f 2 ; done | sort -u | wc -l)"

for i in "${PWD}"/*.opus ; do
    no="$(opustags "${i}" | grep -E '^TRACKNUMBER=' | cut -d '=' -f 2)"
    title="$(opustags "${i}" | grep -E '^TITLE=' | rev | cut -d '=' -f 1 | rev | sed 's#/#_#g')"
    disc="$(opustags "${i}" | grep -E '^DISCNUMBER=' | cut -d '=' -f 2)"

    printf -v no "%02d" "${no#0}"

    fn="${no} - ${title}.opus"

    if [[ "${discs}" -gt 1 ]] ; then
        fn="${disc}.${fn}"
    fi

    if [[ ! -f "${fn}" ]] ; then
        mv "${i}" "${fn}"
    fi
done
