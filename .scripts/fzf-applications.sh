#!/usr/bin/env bash

selected="$(find /usr/share/applications ~/.local/share/applications -name '*.desktop' -print0 | \
    xargs -0 grep -m 1 "Name=" | \
    fzf -d "=" --with-nth 2 --layout=reverse-list)"

if [[ -z "${selected}" ]] ; then
    echo "No application selected" >&2
    exit 1
fi

detach gtk-launch "$(cut -d ':' -f 1 <<< "${selected}" | xargs basename)"
