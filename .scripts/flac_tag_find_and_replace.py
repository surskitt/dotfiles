#!/usr/bin/env python

import argparse

import mutagen.flac


argparser = argparse.ArgumentParser(prog="flac_find_and_replace", description="Find and replace within flac tag")

argparser.add_argument("tag")
argparser.add_argument("find")
argparser.add_argument("replace")
argparser.add_argument("flacs", nargs="+")

args = argparser.parse_args()

for f in args.flacs:
    flac = mutagen.flac.FLAC(f)

    old_values = flac.tags.get(args.tag)

    if old_values is None:
        continue

    # new_values = [replace_value(i, args.old, args.new) for i in old_values]
    new_values = [i.replace(args.find, args.replace) for i in old_values]

    flac.tags[args.tag] = new_values
    flac.save()
