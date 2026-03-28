#!/usr/bin/env python

import sys
import argparse

import mutagen.flac


return_code = 0

argparser = argparse.ArgumentParser(prog="flac_tagger", description="Simple flac tagger")

argparser.add_argument("-m", "--missing", action="store_true")
argparser.add_argument("-s", "--unsplit", action="store_true")
argparser.add_argument("-L", "--latin", action="store_true")
argparser.add_argument("-e", "--empty", action="store_true")
argparser.add_argument("-u", "--unique", action="store_true")
argparser.add_argument("-b", "--bad", action="store_true")
argparser.add_argument("flacs", nargs="+")

args = argparser.parse_args()

missing = args.missing
unsplit = args.unsplit
latin = args.latin
empty = args.empty
unique = args.unique
bad = args.bad

if all(not i for i in [missing, unsplit, latin, empty, unique, bad]):
    missing, unsplit, latin, empty, unique, bad = [True]*6

flacs = [(f, mutagen.flac.FLAC(f)) for f in args.flacs]

for (f, flac) in flacs:
    if missing:
        for i in ["TITLE", "ARTIST", "ALBUMARTIST", "ALBUM", "GENRE", "DATE", "RELEASEDATE", "YEAR", "LABEL", "UPC", "TRACKNUMBER", "URL"]:
            val = flac.tags.get(i)
            if (val is None) or any(j == "" for j in val):
                print(f"{f} is missing {i} tag")
                return_code = 1

        if len(flac.pictures) == 0:
            print(f"{f} is missing album art")
            return_code = 1

    if unsplit:
        for i in ["ARTIST", "ALBUMARTIST", "GENRE", "COMPOSER", "LYRICIST", "AUTHOR"]:
            val = flac.tags.get(i)

            if val is None or len(val) > 1:
                continue

            val_single = val[0]

            if val_single in ["Rhythm & Blues"]:
                continue

            if any(j in val_single for j in [",", "&", ";", "/"]):
                print(f"{f} may have unsplit {i} tag ({val_single})")
                return_code = 1

        for i in ["ARTIST", "ALBUMARTIST", "TITLE"]:
            val = flac.tags.get(i)

            if val is None:
                continue

            for v in val:
                if "feat" in v:
                    print(f"{f} may have embedded featured artists in {i} tag ({v})")
                    return_code = 1


    if latin:
        for tag, val in flac.tags:
            if tag.upper() in ["LYRICS"]:
                continue

            for i in ["℗", "©", "è", "’", "ä", "ó", "í", "☆", "♡", "Ÿ", "ú", "ū", "×", "～", "ù", "Ω", "ñ", "Σ", "ö", "÷", "ü", "é", "É"]:
                val = val.replace(i, "")

            if not val.isascii():
                print(f"{f} may have non latin characters in {tag.upper()} tag ({val})")
                return_code = 1

    if empty:
        for tag, val in flac.tags:
            if val == "":
                print(f"{f} has empty {tag.upper()} tag")
                return_code = 1

    if bad:
        for i in ["GENRE", "LABEL"]:
            val = flac.tags.get(i)
            
            if val is None:
                continue

            for v in val:
                for j in ["Asiatische Musik", "Aziatische Muziek", "Asian Music", "Self-Released", "Film Scores", "Filme", "Filmmusik", "Films/Games", "Videospiele", "Klassik"]:
                    if j in v:
                        print(f"{f} has bad value in {i} tag ({j})")
                        return_code = 1

        for tag, val in flac.tags:
            if tag.upper() in ["LYRICS"]:
                continue

            if "  " in val:
                print(f"{f} has double spaces in {tag.upper()} tag ({val})")

        for tag in ["MAIN_ARTIST", "LENGTH", "COMPATIBLE_BRANDS", "MAJOR_BRAND", "MINOR_VERSION", "PUBLISHER", "RELEASETIME", "SORT_ALBUM", "SORT_ALBUM_ARTIST", "SORT_ARTIST", "SORT_COMPOSER", "SORT_NAME"]:
            if tag in flac.tags:
                print(f"{f} has unwanted {tag} tag ")
                return_code = 1


if unique:
    for tag in ["URL", "VERSION"]:
        values = {s for (f, i) in flacs for s in i.tags.get(tag, [])}

        if len(values) > 1:
            print(f"flacs have unique values in {tag} tag")
            return_code = 1

sys.exit(return_code)
