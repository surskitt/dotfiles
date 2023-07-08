#/usr/bin/env bash

BOOKMARKS_FILE="$HOME/.config/fzf-bookmarks/bookmarks.txt"

if [[ ! -f "${BOOKMARKS_FILE}" ]]; then
    echo "Error: bookmarks file does not exist" >&2
    exit 1
fi

selected="$(fzf +m --layout=reverse-list < "${BOOKMARKS_FILE}")"

# echo "${selected}"

# if [[ "${selected}" =~ " " ]];
#     selected="$(cut -d ' ' -f 2 <<< "${selected}")"
# fi

if [[ "${selected}" = *[[:space:]]* ]]; then
    selected="$(cut -d ' ' -f 2 <<< "${selected}")"
fi

xdg-open "${selected}"
