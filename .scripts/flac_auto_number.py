#!/usr/bin/env python

import argparse

import mutagen.flac

argparser = argparse.ArgumentParser(prog="flac_auto_number", description="Autonumber flac tracknumbers")
argparser.add_argument("flacs", nargs="+")
args = argparser.parse_args()

for n, f in enumerate(args.flacs, 1):
    print(f"{f} - {n}")
    flac = mutagen.flac.FLAC(f)
    flac.tags["TRACKNUMBER"] = str(n)
    flac.save()
