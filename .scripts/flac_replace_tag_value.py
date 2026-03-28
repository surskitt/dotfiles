#!/usr/bin/env python

import argparse

import mutagen.flac

argparser = argparse.ArgumentParser(prog="flac_replace_tag_value", description="Replace specific value of given tag")

argparser.add_argument("tag")
argparser.add_argument("old")
argparser.add_argument("new")
argparser.add_argument("flacs", nargs="+")

args = argparser.parse_args()

def replace_value(value, old, new):
    if value == old:
        return new

    return value

for f in args.flacs:
    flac = mutagen.flac.FLAC(f)

    old_values = flac.tags.get(args.tag)

    if old_values is None:
        continue

    new_values = [replace_value(i, args.old, args.new) for i in old_values]

    flac.tags[args.tag] = new_values
    flac.save()
