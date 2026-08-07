#!/usr/bin/env python

import argparse
import re

import mutagen.flac

argparser = argparse.ArgumentParser(
    prog="flac_split_feat", description="Split feat artists from artist tag"
)

argparser.add_argument("-y", "--confirm", action="store_true")
argparser.add_argument("fns", nargs="+")

args = argparser.parse_args()

for fn in args.fns:
    flac = mutagen.flac.FLAC(fn)

    artists = flac.tags["ARTIST"]

    new_artists = []

    for artist in artists:
        search = re.findall(r"[Ff]eat.*? (.*)", artist)
        sub = re.sub(r"[Ff]eat.*? (.*)", "", artist)

        searchs = [s.strip() for i in search for s in i.split("&")]
        subs = [i.strip() for i in sub.split("&")]

        new_artists = subs + searchs

    if new_artists == artists:
        continue

    print(f"=== {fn}")
    print(f"Current Artists: {artists}")
    print(f"New Artists: {new_artists}")
    print()

    if not args.confirm:
        continue

    flac.tags["ARTIST"] = new_artists

    flac.save()
