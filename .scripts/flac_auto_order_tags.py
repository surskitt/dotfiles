#!/usr/bin/env python

import argparse

import mutagen.flac

argparser = argparse.ArgumentParser(
    prog="flac_auto_order_tags",
    description="Automatically order flac tags",
)

argparser.add_argument("fns", nargs="+")

args = argparser.parse_args()

for fn in args.fns:
    flac = mutagen.flac.FLAC(fn)

    album_artists = flac.tags.get("ALBUMARTIST")
    artists = flac.tags.get("ARTIST")

    for tag in ["ARTIST"]:
        val = flac.tags.get(tag)

        if not val:
            continue

        album_artist_in_val = [i for i in album_artists if i in val]
        val_not_in_album_artists = [i for i in val if i not in album_artists]
        new_val = album_artist_in_val + val_not_in_album_artists

        flac.tags[tag] = new_val

    for tag in ["COMPOSER", "LYRICIST", "PERFORMER"]:
        val = flac.tags.get(tag)

        if not val:
            continue

        artist_in_val = [i for i in artists if i in val]
        val_not_in_artists = [i for i in val if i not in artists]
        new_val = artist_in_val + val_not_in_artists

        flac.tags[tag] = new_val

    flac.save()
