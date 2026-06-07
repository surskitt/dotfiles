#!/usr/bin/env bash

dirs=(
    "/mnt/nfs/mallard/media/downloads/torrents/music"
    "/mnt/nfs/mallard/media/downloads/torrents/uploads/music"
)

readarray -t torrent_files < <(find "${dirs[@]}" -name torrents.json)

for torrent_file in "${torrent_files[@]}"; do
    parent="${torrent_file%/*}"
    dir_name="${parent##*/}"

    parent_escaped="$(sed 's#\[#\\[#g;s#\]#\\]#g' <<<"${parent}")"
    dir_name_escaped="$(sed 's#\[#\\[#g;s#\]#\\]#g' <<<"${dir_name}")"

    sibling_count="$(find "${parent}" -mindepth 1 | grep -v torrents.json | wc -l)"

    if [[ "${sibling_count}" -gt 0 ]]; then
        continue
    fi

    readarray -t move_dirs < <(find "${dirs[@]}" -name "${dir_name_escaped}" | grep -v -F "${parent}")

    move_dirs_real=()

    for move_dir in "${move_dirs[@]}"; do
        move_dir_sibling_count="$(find "${move_dir}" -mindepth 1 | grep -v torrents.json | wc -l)"

        if [[ "${move_dir_sibling_count}" -gt 0 ]]; then
            move_dirs_real+=("${move_dir}")
        fi
    done

    if [[ "${#move_dirs_real[@]}" -eq 1 ]]; then
        echo "${torrent_file}"
        echo "->"
        echo "${move_dirs_real[0]}"
        echo

        mv "${torrent_file}" "${move_dirs_real[0]}"/
        rmdir "${parent}"
    fi
done
