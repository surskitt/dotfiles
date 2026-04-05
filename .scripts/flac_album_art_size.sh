#!/usr/bin/env bash

for i in *.flac ; do
    metaflac "${i}" --export-picture-to=- | wc -c | numfmt --to=si
done | sort -u
