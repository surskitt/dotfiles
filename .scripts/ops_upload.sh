#!/usr/bin/env bash

case "${PWD##*/}" in
    -*|+*|=*)
        echo "Error: directory begins with symbol" >&2
        exit 1
        ;;
    *)
        ;;
esac

album_summary.py

propolis \
    --metadata-root="$(mktemp -d)" \
    --no-overview \
    --no-specs \
    --only-problems \
    .

salmon check integrity .

# url="$(metaflac --show-tag=URL *.flac | cut -d = -f 2 | sort -u)"
#
# if [[ -n "${url}" && "$(wc -l <<< "${url}")" -eq 1 ]] ; then
#     url_arg="--source-url ${url}"
# fi

salmon up \
    --skip-up \
    --skip-mqa \
    --skip-integrity-check \
    -s WEB \
    -L $(for i in $(seq "$(ls *.flac | wc -l)") ; do echo -n "-sp ${i} " ; done) \
    -t RED \
    "${PWD}"

ops_gen_downconv_rd.sh | tee /dev/tty | wl-copy -n
