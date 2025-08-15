#!/usr/bin/env bash

main() {
    local json="${1}"

    key=$(jq -r 'keys_unsorted|.[]' <<< "${json}"|tofi --prompt-text "menu: ")
    [ -z "${key}" ] && return 1

    item=$(jq ".\"${key}\"" <<< "${json}")
    item_type=$(jq -r 'type' <<< "${item}")

    case "${item_type}" in
        string)
            cmd=$(echo "${item}"|cut -d '"' -f 2|sed 's/\\t/	/g')
            eval "${cmd}" || main "${json}"
            ;;
        object)
            main "${item}" || main "${json}"
            ;;
        *)
            return 1
            ;;
    esac
}

# if [ "${#}" -lt 1 ]; then
#     jsonfile=~/.config/tofi-menu/menu.json
# else
#     jsonfile="${1}"
# fi

jsonfile="${1:-"${HOME}/.config/tofi-menu/menu.json"}"

[ ! -f "${jsonfile}" ] && {
    echo "Error: ${jsonfile} does not exist" >&2
    exit 1
}

json=$(< "${jsonfile}")

main "${json}"
