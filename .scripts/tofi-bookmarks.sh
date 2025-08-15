#/usr/bin/env bash

BOOKMARKS_FILE="$HOME/.config/tofi-bookmarks/bookmarks.txt"

if [[ ! -f "${BOOKMARKS_FILE}" ]]; then
    echo "Error: bookmarks file does not exist" >&2
    exit 1
fi

selected="$(tofi --prompt-text " : " < "${BOOKMARKS_FILE}")"

# echo "${selected}"

# if [[ "${selected}" =~ " " ]];
#     selected="$(cut -d ' ' -f 2 <<< "${selected}")"
# fi

if [[ "${selected}" = *[[:space:]]* ]]; then
    selected="$(cut -d ' ' -f 2 <<< "${selected}")"
fi

if [[ -z "${selected}" ]] ; then
    exit 1
fi

xdg-open "${selected}"
