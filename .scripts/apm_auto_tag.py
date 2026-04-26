#!/usr/bin/env python

import argparse
import os

import mutagen.flac

argparser = argparse.ArgumentParser(prog="apm_auto_tag", description="Autotag apple music flacs")
argparser.add_argument("flacs", nargs="+")
args = argparser.parse_args()

flacs = [(i, mutagen.flac.FLAC(i)) for i in args.flacs]

disc_count = len({i.tags["DISCNUMBER"][0] for _, i in flacs})

for name, flac in flacs:
    disc_number = flac.tags["DISCNUMBER"][0].split("/")[0]
    track_number = flac.tags["TRACKNUMBER"][0].split("/")[0] # .zfill(2)
    title = flac.tags["TITLE"][0].replace("/", "_")

    flac.tags["DISCNUMBER"] = disc_number
    flac.tags["TRACKNUMBER"] = track_number

    flac.tags["RELEASEDATE"] = flac.tags["DATE"]
    flac.tags["YEAR"] = flac.tags["DATE"][0].split("-")[0]

    for tag in ["COMPATIBLE_BRANDS", "MAJOR_BRAND", "MINOR_VERSION", "RELEASETIME", "SORT_ALBUM", "SORT_ALBUM_ARTIST", "SORT_ARTIST", "SORT_COMPOSER", "SORT_NAME", "PUBLISHER", "COMPOSERLYRICIST", "CREATION_TIME"]:
        if tag in flac.tags:
            flac.pop(tag)

    label = " ".join(flac.tags["COPYRIGHT"][0].split()[2:])
    flac.tags["LABEL"] = label

    flac.save()

    fn_track_number = track_number.zfill(2)

    new_name = f"{fn_track_number} - {title}.flac"

    if disc_count > 1:
        new_name = f"{disc_number}-{new_name}"

    os.rename(name, new_name)
