#!/usr/bin/env python

import argparse
import glob
import html
import json
import pathlib
import sys
import time

import requests


def parse_args():
    argparser = argparse.ArgumentParser(
        prog="gazelle_save_torrent_id",
        description="Save gazelle torrent IDs to a local file",
    )

    argparser.add_argument(
        "-r",
        "--root-directory",
        default="/mnt/nfs/mallard/media/downloads/torrents/music",
        type=pathlib.Path,
    )
    argparser.add_argument("-s", "--site", type=str, required=True)
    argparser.add_argument("-k", "--api-key", type=str, required=True)
    argparser.add_argument("-i", "--id", type=str, required=True)
    argparser.add_argument("-c", "--count", type=int, default=9999)

    return argparser.parse_args()


def request_sleep(*args, **kwargs):
    r = requests.get(*args, **kwargs)

    if r.status_code == 429:
        print(r.headers)

        print("Sleeping for 10 seconds after 429 status")
        time.sleep(10)

        return request_sleep(*args, **kwargs)

    return r


def main():
    args = parse_args()

    api_url = f"https://{args.site}/ajax.php"

    headers = {"Authorization": args.api_key}
    params = {
        "action": "user_torrents",
        "id": args.id,
        "type": "uploaded",
        "limit": args.count,
    }

    r = request_sleep(api_url, headers=headers, params=params)
    rj = r.json()

    results = rj["response"]["uploaded"]

    for result in results:
        torrent_id = result["torrentId"]
        params = {"action": "torrent", "id": torrent_id}

        r = request_sleep(api_url, headers=headers, params=params)
        rj = r.json()

        torrent_id = rj["response"]["torrent"]["id"]
        torrent_root_dir = html.unescape(rj["response"]["torrent"]["filePath"])

        torrent_dir_search = list(
            args.root_directory.rglob(glob.escape(torrent_root_dir))
        )

        if len(torrent_dir_search) == 0:
            print(f"Error: no directories found for {torrent_id} - {torrent_root_dir}")
            continue

        if len(torrent_dir_search) > 1:
            print(
                f"Error: multiple directories found for {torrent_id} - {torrent_root_dir}"
            )
            continue

        torrent_local_dir = torrent_dir_search[0]

        json_path = torrent_local_dir.joinpath("torrents.json")

        torrent_ids = {}

        if json_path.exists():
            torrent_ids = json.loads(json_path.read_text())

        torrent_ids[args.site] = torrent_id

        json_path.write_text(json.dumps(torrent_ids) + "\n")

        print(f"Wrote id {torrent_id} to {json_path}")


if __name__ == "__main__":
    main()
