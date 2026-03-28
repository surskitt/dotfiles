#!/usr/bin/env python

import argparse

import mutagen.flac


argparser = argparse.ArgumentParser(prog="flac_split_tag", description="Simple flac tag splitter")

argparser.add_argument("tag")
argparser.add_argument("field")
argparser.add_argument("flacs", nargs="+")

args = argparser.parse_args()

for f in args.flacs:
    flac = mutagen.flac.FLAC(f)

    old_val = flac.tags.get(args.tag)

    if old_val is None:
        continue

    new_val = [i.strip() for s in old_val for i in s.split(args.field)]

    flac.tags[args.tag] = new_val
    flac.save()
