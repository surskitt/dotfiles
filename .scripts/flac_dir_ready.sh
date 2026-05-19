#!/usr/bin/env bash

dir_name="${PWD##*/}"
dir_parent="${PWD%/*}"

if [[ "${dir_name}" != [-+_]* ]] ; then
    echo "Error: dir already ready" >&2
    exit 1
fi

mv "${dir_parent}/${dir_name}" "${dir_parent}/${dir_name#?}"
