#!/usr/bin/env python

import argparse
import subprocess

import qbittorrentapi

parser = argparse.ArgumentParser(prog="qb_add", description="add torrent files to qbittorrent")

parser.add_argument("-f", "--file", required=True)
parser.add_argument("-c", "--category", default="uploads")
parser.add_argument("-t", "--tags", default="uploads")
parser.add_argument("-s", "--start", action="store_true")
parser.add_argument("-r", "--recheck", action="store_true")

args = parser.parse_args()

mallard_domain = subprocess.run(["gopass", "mallard_domain"], capture_output=True, encoding="utf-8").stdout.strip()
qb_host = f"https://qb.{mallard_domain}"

client = qbittorrentapi.Client(host=qb_host)

client.torrents_add(torrent_files=args.file, category=args.category, tags=args.tags, is_paused=(not args.start))

if args.recheck:
    torrents = client.torrents_info(category=args.category)
    newest = list(sorted(torrents, key=lambda x: x["added_on"], reverse=True))[0]

    client.torrents_recheck(newest["hash"])
