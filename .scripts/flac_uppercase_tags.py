#!/usr/bin/env python

import argparse

import mutagen.flac


argparser = argparse.ArgumentParser(prog="flac_uppercase_tags", description="Uppercase flac tag names")
argparser.add_argument("flacs", nargs="+")
args = argparser.parse_args()


for f in args.flacs:
    flac = mutagen.flac.FLAC(f)

    for tag in flac.tags.keys():
        val = flac.tags[tag]
        flac.tags[tag.upper()] = val
        flac.save()
