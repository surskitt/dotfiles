#!/usr/bin/env bash

# storedir=${PASSWORD_STORE_DIR-~/.password-store}
storedir="${HOME}/.local/share/gopass/stores/root"

get_entries() {
    while read -r entry; do
        echo "${entry%\.*}"
    done <<< "$(find "${storedir}" -name '*.gpg' -printf '%P\n'|sort)"
}

selection=$(tofi <<< "$(get_entries)")
[ -z "${selection}" ] && exit 1

gopass -c "${selection}"
