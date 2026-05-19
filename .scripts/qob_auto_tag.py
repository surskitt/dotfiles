#!/usr/bin/env python

import argparse
import os

import mutagen.flac

argparser = argparse.ArgumentParser(
    prog="qoqobuto_tag", description="Autotag qobuz music flacs"
)
argparser.add_argument("flacs", nargs="+")
args = argparser.parse_args()


def unique(seq):
    seen = set()
    seen_add = seen.add
    return [x for x in seq if not (x in seen or seen_add(x))]


flacs = [(i, mutagen.flac.FLAC(i)) for i in args.flacs]

for name, flac in flacs:
    flac.tags["RELEASEDATE"] = flac.tags["DATE"]
    flac.tags["UPC"] = flac.tags["BARCODE"]

    if "COMPOSER" in flac.tags:
        flac.tags["COMPOSER"] = unique(flac.tags["COMPOSER"])

    flac.save()
