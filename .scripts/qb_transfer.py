#!/usr/bin/env python

import argparse

import qbittorrentapi

parser = argparse.ArgumentParser(prog="qb_add", description="add torrent files to qbittorrent")

parser.add_argument("-c", "--category", default="uploads")
parser.add_argument("-t", "--tags", default="uploads")
parser.add_argument("torrent_hash")

args = parser.parse_args()

mallard_domain = subprocess.run(["gopass", "mallard_domain"], capture_output=True, encoding="utf-8").stdout.strip()
mallard_qb_host = f"https://qb.{mallard_domain}"
serpentine_qb_host = f"https://qb.s.{mallard_domain}"

mallard_client = qbittorrentapi.Client(host=mallard_qb_host)
serpentine_client = qbittorrentapi.Client(host=serpentine_qb_host)

torrent = mallard_client.torrents_export(torrent_hash=args.torrent_hash)

serpentine_client.torrents_add(torrent_files=torrent, category=args.category, tags=args.tags, is_paused=True)
serpentine_client.torrents_recheck(args.torrent_hash)
