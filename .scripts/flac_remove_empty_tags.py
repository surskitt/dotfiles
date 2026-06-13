#!/usr/bin/env python

import argparse

import mutagen.flac

argparser = argparse.ArgumentParser(
    prog="flac_remove_empty_tags", description="Remove empty tags from flac files"
)

argparser.add_argument("fns", nargs="+")

args = argparser.parse_args()

for fn in args.fns:
    flac = mutagen.flac.FLAC(fn)

    for tag, val in flac.tags.items():
        if any(i == "" for i in val):
            flac.tags[tag] = []

    flac.save()
