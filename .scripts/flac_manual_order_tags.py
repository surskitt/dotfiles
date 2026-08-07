#!/usr/bin/env python

import argparse

import mutagen.flac

argparser = argparse.ArgumentParser(
    prog="flac_auto_order_tags",
    description="Manually order flac tags",
)

argparser.add_argument("tag")
argparser.add_argument("fns", nargs="+")

args = argparser.parse_args()

for fn in args.fns:
    flac = mutagen.flac.FLAC(fn)

    vals = flac.tags.get(args.tag)

    print(fn)
    for n, i in enumerate(vals, 1):
        print(f"{n}: {i}")

    ordering_input = input("Tag ordering (space separated list): ")
    print()

    if not ordering_input:
        continue

    try:
        ordering = [int(i) - 1 for i in ordering_input.split()]
    except:
        print("Error: Could not extract ordering")
        continue

    new_order = [vals[i] for i in ordering]

    flac.tags[args.tag] = new_order
    flac.save()
