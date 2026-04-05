#!/usr/bin/env bash

firstflac="$(\ls "${PWD}"/*.flac 2>/dev/null | head -1)"

if [[ -z "${firstflac}" ]] ; then
    echo "No flacs found in current dir" >&2
    exit 1
fi

dr="$(dr14_tmeter --quiet -n -p .)"

specs="$(salmon specs -f . | tee /dev/tty | grep -- '^\[hide')"

cat << EOF
[hide=Spectrograms]${specs}[/hide]

[hide=DR]${dr}[/hide]
EOF
