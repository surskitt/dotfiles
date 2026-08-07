#!/usr/bin/env python

import argparse
import re

import mutagen.flac

argparser = argparse.ArgumentParser(
    prog="flac_split_feat", description="Split feat artists from title to artist tag"
)

argparser.add_argument("-y", "--confirm", action="store_true")
argparser.add_argument("fns", nargs="+")

args = argparser.parse_args()

for fn in args.fns:
    flac = mutagen.flac.FLAC(fn)

    title = flac.tags["TITLE"][0]
    artists = flac.tags["ARTIST"]

    search = re.findall(r"\([Ff]eat.*? (.*?)\)", title)
    search += re.findall(r"\[[Ff]eat.*? (.*?)\]", title)
    # search += re.findall(r"[Ff]eat.*? (.*)", title)

    if not search:
        continue

    search = set(search)

    new_title = " ".join(re.sub(r"\([Ff]eat.*? .*?\)", "", title).split())
    new_title = " ".join(re.sub(r"\[[Ff]eat.*? .*?\]", "", new_title).split())
    # new_title = " ".join(re.sub(r"[Ff]eat.*", "", new_title).split())

    print(f"=== {fn}")
    print(f"Artists: {search}")
    print(f"New title: {new_title}")
    print()

    if not args.confirm:
        continue

    for s in search:
        for ss in s.split(","):
            if s in artists:
                continue

            artists += [s.strip()]

    flac.tags["ARTIST"] = artists
    flac.tags["TITLE"] = [new_title]

    flac.save()
