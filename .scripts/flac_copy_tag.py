#!/usr/bin/env python

import argparse

import mutagen.flac

argparser = argparse.ArgumentParser(prog="flac_copy_tag", description="Copy flac tag to another tag")

argparser.add_argument("from_tag")
argparser.add_argument("to_tag")
argparser.add_argument("flacs", nargs="+")

args = argparser.parse_args()

for f in args.flacs:
    flac = mutagen.flac.FLAC(f)

    flac.tags[args.to_tag] = flac.tags[args.from_tag]

    flac.save()
