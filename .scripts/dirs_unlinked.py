#!/usr/bin/env python

import argparse
import os
import sys
import pathlib
import glob

parser = argparse.ArgumentParser(prog="dirs_unlinked", description="find files in dir1 that are not in dir2")

parser.add_argument("dir1")
parser.add_argument("dir2")

args = parser.parse_args()

for dir in [args.dir1, args.dir2]:
    if not os.path.isdir(dir):
        print(f"Error: {dir} is not a directory", file=sys.stderr)
        sys.exit(1)

dir1 = pathlib.Path(args.dir1)
dir2 = pathlib.Path(args.dir2)

dir1_flacs = {os.stat(p).st_ino: p for p in dir1.glob("**/*.flac")}
dir2_inodes = [os.stat(p).st_ino for p in dir2.glob("**/*.flac")]

for inode, path in dir1_flacs.items():
    if inode not in dir2_inodes:
        print(path)
