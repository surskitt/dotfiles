#!/usr/bin/env python

import argparse

import mutagen.flac

argparser = argparse.ArgumentParser(
    prog="flac_remove_duplicate_tags",
    description="Remove duplicate tags from flac files",
)

argparser.add_argument("fns", nargs="+")

args = argparser.parse_args()

for fn in args.fns:
    flac = mutagen.flac.FLAC(fn)

    for tag, val in flac.tags.items():
        flac[tag] = list(dict.fromkeys(val))

    flac.save()
