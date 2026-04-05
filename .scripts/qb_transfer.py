#!/usr/bin/env python

import argparse
import subprocess

import qbittorrentapi

parser = argparse.ArgumentParser(prog="qb_transfer", description="transfer torrents from one qb to another")

parser.add_argument("-c", "--category")
parser.add_argument("-t", "--tags")
parser.add_argument("torrent_hash", nargs="+")

args = parser.parse_args()

mallard_domain = subprocess.run(["gopass", "mallard_domain"], capture_output=True, encoding="utf-8").stdout.strip()
mallard_qb_host = f"https://qb.{mallard_domain}"
serpentine_qb_host = f"https://qb.s.{mallard_domain}"

mallard_client = qbittorrentapi.Client(host=mallard_qb_host)
serpentine_client = qbittorrentapi.Client(host=serpentine_qb_host)

for hash in args.torrent_hash:
    torrent = mallard_client.torrents_export(torrent_hash=hash)

    serpentine_client.torrents_add(torrent_files=torrent, category=args.category, tags=args.tags, is_paused=True)
    serpentine_client.torrents_recheck(hash)
