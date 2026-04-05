#!/usr/bin/env bash

tag="${1}"
field="${2}"

shift 2

opus=( "${@}" )

for o in "${opus[@]}" ; do
    opus_tags="$(opustags "${o}")"
    new_opus_tags="$(sed "s/${field} /\n${tag}=/g" <<< "${opus_tags}")"

    opustags -i -d "${tag}" "${o}"
    opustags -i -S "${o}" <<< "${new_opus_tags}"
done
