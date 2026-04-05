#!/usr/bin/env python

import argparse
import math
import subprocess

import termcolor
import mutagen.flac


def red(msg):
    return termcolor.colored(msg, "red")


def green(msg):
    return termcolor.colored(msg, "green")


def ok_or_error(ok, ok_msg, error_msg):
    if ok:
        return termcolor.colored(ok_msg, "green")

    return termcolor.colored(error_msg, "red")


def check_lengths(flacs):
    lengths = [math.floor(i.info.length) == 30 for i in flacs]
    return not all(lengths)


def check_24bit(flacs):
    bitdepths = [i.info.bits_per_sample == 24 for i in flacs]
    return not any(bitdepths)


def main():
    argparser = argparse.ArgumentParser(
        prog="flac_checks", description="Run various checks on flac files"
    )
    argparser.add_argument("flacs", nargs="+")
    args = argparser.parse_args()

    flacs = [mutagen.flac.FLAC(i) for i in args.flacs]

    good_lengths = check_lengths(flacs)
    msg = ok_or_error(good_lengths, "Track lengths do not look like samples", "Track lengths look like samples")
    print(msg)

    good_bitdepths = check_24bit(flacs)
    msg = ok_or_error(good_bitdepths, "Tracks are all 16 bit", "Tracks contain 24 bit flacs")
    print(msg)


if __name__ == "__main__":
    main()
