#!/usr/bin/env python

import argparse
import sys

import mutagen.flac
import mutagen.oggopus

argparser = argparse.ArgumentParser(
    prog="flac_tagger", description="Simple flac tagger"
)

argparser.add_argument("-A", "--albumartist", action="append")
argparser.add_argument("-L", "--lyricist", action="append")
argparser.add_argument("-T", "--release-type", action="append")
argparser.add_argument("-U", "--url", action="append")
argparser.add_argument("-Y", "--year", action="append")
argparser.add_argument("-a", "--artist", action="append")
argparser.add_argument("-b", "--album", action="append")
argparser.add_argument("-c", "--composer", action="append")
argparser.add_argument("-d", "--date", action="append")
argparser.add_argument("-g", "--genre", action="append")
argparser.add_argument("-l", "--label", action="append")
argparser.add_argument("-t", "--title", action="append")
argparser.add_argument("-u", "--upc", action="append")
argparser.add_argument("-v", "--version", action="append")
argparser.add_argument("-C", "--copyright", action="append")
argparser.add_argument("-n", "--catalog-number", action="append")
argparser.add_argument("-B", "--barcode", action="append")
argparser.add_argument("-p", "--performer", action="append")
argparser.add_argument("--original-year", action="append")
argparser.add_argument("--original-date", action="append")
argparser.add_argument("--release-year", action="append")
argparser.add_argument("--release-date", action="append")
argparser.add_argument("fns", nargs="+")

args = argparser.parse_args()

for fn in args.fns:
    if fn.endswith(".flac"):
        f = mutagen.flac.FLAC(fn)
    elif fn.endswith(".opus"):
        f = mutagen.oggopus.OggOpus(fn)
    else:
        print("Error: unsupported filetype", file=sys.stderr)
        continue

    if args.title:
        f.tags["TITLE"] = args.title

    if args.artist:
        f.tags["ARTIST"] = args.artist

    if args.albumartist:
        f.tags["ALBUMARTIST"] = args.albumartist

    if args.album:
        f.tags["ALBUM"] = args.album

    if args.composer:
        f.tags["COMPOSER"] = args.composer

    if args.label:
        f.tags["LABEL"] = args.label

    if args.genre:
        f.tags["GENRE"] = args.genre

    if args.date:
        f.tags["DATE"] = args.date
        f.tags["RELEASEDATE"] = args.date

    if args.year:
        f.tags["YEAR"] = args.year
        f.tags["RELEASEYEAR"] = args.year

    if args.lyricist:
        f.tags["LYRICIST"] = args.lyricist

    if args.upc:
        f.tags["UPC"] = args.upc

    if args.url:
        f.tags["URL"] = args.url

    if args.version:
        f.tags["ALBUMVERSION"] = args.version

    if args.release_type:
        f.tags["RELEASETYPE"] = args.release_type

    if args.copyright:
        f.tags["COPYRIGHT"] = args.copyright

    if args.catalog_number:
        f.tags["CATALOGNUMBER"] = args.catalog_number

    if args.barcode:
        f.tags["BARCODE"] = args.barcode

    if args.performer:
        f.tags["PERFORMER"] = args.performer

    if args.original_year:
        f.tags["ORIGINALYEAR"] = args.original_year

    if args.original_date:
        f.tags["ORIGINALDATE"] = args.original_date

    if args.release_year:
        f.tags["RELEASEYEAR"] = args.release_year

    if args.release_date:
        f.tags["RELEASEDATE"] = args.release_date

    f.save()
