#!/usr/bin/env python

import argparse
import base64
import itertools
import json
import operator
import os
import pathlib
import re
import subprocess
import sys
import tempfile
import urllib.parse

import mutagen.flac
import requests

SOURCE_ICONS = {
    "https://ptpimg.me/m265v2.png": "https://files.catbox.moe/2gwqip.png",  # deezer
    "https://ptpimg.me/e4d045.png": "https://files.catbox.moe/yts9t7.png",  # qobuz
    "https://ptpimg.me/0z2x90.png": "https://files.catbox.moe/nz7dhh.png",  # itunes
    "https://ptpimg.me/13y32k.png": "https://files.catbox.moe/l28j3z.png",  # discogs
    "https://ptpimg.me/mt4ql3.png": "https://files.catbox.moe/l28j3z.png",  # discogs
    "https://ptpimg.me/5vxo23.png": "https://files.catbox.moe/1zzxzr.png",  # tidal
    "https://ptpimg.me/pu93q2.png": "https://files.catbox.moe/7a59ce.png",  # flac 16 bit
    "https://ptpimg.me/67vp4c.png": "https://files.catbox.moe/7a59ce.png",  # flac 16 bit
    "https://ptpimg.me/56plwd.png": "https://files.catbox.moe/q1wjj7.png",  # musicbrainz
}

URL_REPLACEMENTS = {
    "https://vgmdb.net": {
        "name": "vgmdb",
        "icon": "https://files.catbox.moe/czu0mx.png",
    },
    "https://vocadb.net": {
        "name": "vocadb",
        "icon": "https://files.catbox.moe/gobyy0.png",
    },
}


def parse_args():
    argparser = argparse.ArgumentParser(
        prog="update_gazelle_release_description",
        description="Update description of gazelle music release",
    )

    argparser.add_argument("-k", "--api-key", required=True)
    argparser.add_argument("-i", "--img-api-key", required=True)
    argparser.add_argument(
        "-d", "--directory", default=os.getenv("PWD"), type=pathlib.Path
    )
    argparser.add_argument("-u", "--url", required=True)
    argparser.add_argument("-s", "--spectrals", action="store_true")
    argparser.add_argument("-f", "--force", action="store_true")

    return argparser.parse_args()


def extract_spectral_block(description):
    out = []
    depth = 0

    for line in description.splitlines():
        if "[hide=Spectrals]" in line:
            depth += 1
            out += [line]
            continue

        if depth == 0:
            continue

        if "[hide" in line:
            depth += 1

        if "[/hide" in line:
            depth -= 1

        out += [line]

    return "\n".join(out)


def extract_flac_info_line(description):
    for line in description.splitlines():
        if line.startswith("[img]") and "kHz" in line:
            return line

    return None


def extract_release_date_line(description):
    for line in description.splitlines():
        if line.startswith("Released on"):
            return line

    return None


def extract_release_url_line(description):
    for line in description.splitlines():
        if line.startswith("[b]More info:[/b]"):
            return line

    return None


def extract_flat_block(description, name):
    out = []
    found = False

    for line in description.splitlines():
        if f"[hide={name}]" in line:
            found = True

        if found:
            out += [line]

        if found and "[/hide]" in line:
            return "\n".join(out)

    return None


def extract_redcurry_block(description):
    out = []
    found = False

    for line in description.splitlines():
        if line.startswith("[align=center]") and "orpheus.network" in line:
            found = True

        if found:
            out += [line]

        if found and "[/align]" in line:
            return "\n".join(out)

    return None


def extract_downconv_section(description):
    out = []
    for line in description.splitlines():
        if any(
            line.startswith(i)
            for i in [
                "Downconverted from",
                "[b]Downconverted from",
                "Encode Specifics:",
                "[b]Encode specifics:[/b]",
                "[b]Transcode process:[/b]",
            ]
        ):
            out += [line]
    if len(out) > 0:
        out = [""] + out
        return "\n".join(out)

    return None


def generate_release_date_line(directory):
    flac_fns = sorted(directory.glob("**/*.flac"))
    flacs = [mutagen.flac.FLAC(i) for i in flac_fns]

    dates = {i.tags["DATE"][0] for i in flacs}

    if len(dates) != 1:
        return None

    date = dates.pop()

    return f"Released on [b]{date}[/b]"


def extract_source_specs(specs):
    bitrate, _, sample_rate_hz, _ = specs.split()

    sample_rate, fraction = sample_rate_hz[:2], sample_rate_hz[2:]

    if fraction != "000":
        sample_rate = f"{sample_rate}.{fraction[0]}"

    return f"{bitrate} bit {sample_rate} KHz"


def format_track_ranges(tracks):
    ranges = []
    for k, g in itertools.groupby(enumerate(tracks), lambda x: x[0] - x[1]):
        group = list(map(operator.itemgetter(1), g))
        if group[0] == group[-1]:
            ranges.append(str(group[0]))
        else:
            ranges.append(f"{group[0]}-{group[-1]}")
    return ", ".join(ranges)


def generate_source_spec_line(flacs):
    source_specs = [(n, i.tags.get("SOURCE_SPECS")) for n, i in enumerate(flacs, 1)]
    source_specs = [(n, i[0]) for n, i in source_specs if i is not None]

    if len(source_specs) == 0:
        return None

    source_specs_dict = {}
    for n, i in source_specs:
        source_specs_dict[i] = source_specs_dict.get(i, []) + [n]

    if len(source_specs_dict.keys()) == 1 and len(source_specs) == len(flacs):
        spec = extract_source_specs(source_specs[0][1])
        return f"[b]Downconverted from source:[/b] {spec}"

    out = []
    for k, v in source_specs_dict.items():
        tracks = format_track_ranges(v)
        spec = extract_source_specs(k)
        out += [f"Tracks {tracks}: {spec}"]
    joined = ", ".join(out)

    return f"[b]Downconverted from source:[/b] {joined}"


def sample_rate_hz_to_khz(sr):
    if (sr % 1000) == 0:
        return sr // 1000
    return sr / 1000


def generate_flac_info_line(directory):
    flac_fns = sorted(directory.glob("**/*.flac"))
    flacs = [mutagen.flac.FLAC(i) for i in flac_fns]

    specs = [(i.info.bits_per_sample, i.info.sample_rate) for i in flacs]

    specs_dict = {}
    for n, i in enumerate(specs, 1):
        specs_dict[i] = specs_dict.get(i, []) + [n]

    if len(specs_dict.keys()) == 1:
        bitrate, sample_rate_hz = specs[0]
        sample_rate = sample_rate_hz_to_khz(sample_rate_hz)
        return f"[img]https://files.catbox.moe/7a59ce.png[/img] [b]{bitrate} bit [color=#2E86C1]{sample_rate}[/color] kHz[/b]"

    out = []
    for k, v in specs_dict.items():
        tracks = format_track_ranges(v)
        bitrate, sample_rate_hz = k
        sample_rate = sample_rate_hz_to_khz(sample_rate_hz)
        out += [
            f"[b]{bitrate} bit [color=#2E86C1]{sample_rate}[/color] kHz[/b] (Tracks {tracks})"
        ]
    joined = " / ".join(out)

    return f"[img]https://files.catbox.moe/7a59ce.png[/img] {joined}"


def generate_encoded_spec_line(flacs):
    encoded_specs = [
        (i.info.bits_per_sample, i.info.sample_rate)
        for i in flacs
        if i.tags.get("SOURCE_SPECS")
    ]

    encoded_specs_dict = {}
    for n, i in enumerate(encoded_specs, 1):
        encoded_specs_dict[i] = encoded_specs_dict.get(i, []) + [n]

    if len(encoded_specs_dict.keys()) == 1:
        bitrate, sample_rate_hz = encoded_specs[0]
        sample_rate = sample_rate_hz_to_khz(sample_rate_hz)

        return f"[b]Encode specifics:[/b] {bitrate} bit {sample_rate} KHz"

    out = []
    for k, v in encoded_specs_dict.items():
        tracks = format_track_ranges(v)
        bitrate, sample_rate_hz = k
        sample_rate = sample_rate_hz_to_khz(sample_rate_hz)
        out += [f"Tracks {tracks}: {bitrate} bit {sample_rate} KHz"]
    joined = ", ".join(out)

    return f"[b]Encode specifics:[/b] {joined}"


def generate_downconv_section(directory):
    out = []

    flac_fns = sorted(directory.glob("**/*.flac"))
    flacs = [mutagen.flac.FLAC(i) for i in flac_fns]

    source_specs_line = generate_source_spec_line(flacs)

    if source_specs_line is None:
        return None

    encoded_specs_line = generate_encoded_spec_line(flacs)
    transcode_process_line = "[b]Transcode process:[/b] [code]sox -V2 -G -R INPUT.flac -b 16 OUTPUT.flac dither[/code]"

    return "\n".join(
        ["", source_specs_line, encoded_specs_line, transcode_process_line]
    )


def generate_tags_block(directory):
    out = "[hide=Tags]"

    flac_fns = sorted(directory.glob("**/*.flac"))

    flacs = [(i.name, mutagen.flac.FLAC(i)) for i in flac_fns]

    for fn, flac in flacs:
        out += f"{fn}:\n"

        for tag, val in sorted(flac.tags, key=lambda x: x[0].upper()):
            out += f"- {tag.upper()}={val}\n"

        out += "\n"

    out += "[/hide]"

    return out


def generate_propolis_block(directory):
    out = "[hide=Propolis Report][pre]"

    with tempfile.TemporaryDirectory() as td:
        propolis_out = subprocess.run(
            ["propolis", f"--metadata-root={td}", "--no-specs", "--json", "."],
            cwd=directory,
            capture_output=True,
        )

    input_json = "\n".join(propolis_out.stdout.decode("utf-8").splitlines()[1:])

    j = json.loads(input_json)

    for check in j["checks"]:
        res = {0: "OK", 1: "--", 2: "--", 3: "!!", 4: "KO"}[check["result"]]
        rule = check["rule"].ljust(10)
        comment = check["result_comment"]

        line = " | ".join([res, rule, comment])
        out += f"{line}\n"

    out += "\n"

    ok_count = j["Passed"]
    ko_count = j["Errors"]
    warning_count = j["Warnings"]

    out += f"{ok_count} checks OK, {ko_count} checks KO, {warning_count} warnings."

    out += "[/pre][/hide]"

    return out


def generate_spectral(fn, temp_dir):
    flac = mutagen.flac.FLAC(fn)
    zoom_startpoint = flac.info.length // 2 if flac.info.length > 5 else 0

    full_path = os.path.join(temp_dir, fn.name + "_full.png")
    zoom_path = os.path.join(temp_dir, fn.name + "_zoom.png")

    sox_out = subprocess.run(
        [
            "sox",
            "--multi-threaded",
            fn,
            "--buffer",
            "128000",
            "-n",
            "remix",
            "1",
            "spectrogram",
            "-x",
            "2000",
            "-y",
            "513",
            "-z",
            "120",
            "-w",
            "Kaiser",
            "-o",
            full_path,
            "remix",
            "1",
            "spectrogram",
            "-x",
            "500",
            "-y",
            "1025",
            "-z",
            "120",
            "-w",
            "Kaiser",
            "-S",
            str(zoom_startpoint),
            "-d",
            "0:02",
            "-o",
            zoom_path,
        ],
    )

    return (full_path, zoom_path)


def catbox_upload(fn, img_api_key):
    data = {"reqtype": "fileupload"}
    with open(fn, "rb") as f:
        files = {"fileToUpload": f}
        r = requests.post("https://catbox.moe/user/api.php", data=data, files=files)

    if r.status_code == 200:
        return r.text.strip()

    print("Error: unable to upload file to catbox")
    sys.exit(1)


def imgbb_upload(fn, img_api_key):
    with open(fn, "rb") as f:
        data = {"key": img_api_key, "image": base64.b64encode(f.read())}
        r = requests.post("https://api.imgbb.com/1/upload", data=data)

    if r.status_code == 200:
        rj = r.json()
        return rj["data"]["url"].strip()

    print("Error: unable to upload file to imgbb")
    sys.exit(1)


def img_upload(fn, img_api_key):
    # return catbox_upload(fn, img_api_key)
    return imgbb_upload(fn, img_api_key)


def generate_spectrals_block(directory, img_api_key):
    out = "[hide=Spectrals]"

    flac_fns = sorted(directory.glob("**/*.flac"))

    with tempfile.TemporaryDirectory() as td:
        for fn in flac_fns:
            out += f"[b]{fn.name} Full [/b]\n"

            full_spec, zoom_spec = generate_spectral(fn, td)
            full_spec_url = img_upload(full_spec, img_api_key)
            zoom_spec_url = img_upload(zoom_spec, img_api_key)

            out += f"[img={full_spec_url}]\n"
            out += f"[hide=Zoomed][img={zoom_spec_url}][/hide]\n\n"

    out += "[/hide]"

    return out


# def replace_icon_urls(text):
#     for k, v in SOURCE_ICONS.items():
#         text = text.replace(k, v)
#
#     return text


def replace_text(text, replacements):
    for k, v in replacements.items():
        text = text.replace(k, v)

    return text


def replace_urls(text):
    for k, v in URL_REPLACEMENTS.items():
        name = v["name"]
        icon = v["icon"]

        urls = re.findall(rf"\[url={k}.*?\].*\[/url\]", text)

        if not urls:
            continue

        for url in urls:
            url_repl = re.sub(r" .*?\[/url\]", f" {name}[/url]", url)
            url_repl = re.sub(r"\[img\].*?\[/img\]", f"[img]{icon}[/img]", url_repl)

            text = text.replace(url, url_repl)

    return text


def main():
    args = parse_args()

    us = urllib.parse.urlsplit(args.url)
    uq = urllib.parse.parse_qs(us.query)

    site = us.netloc
    api_url = f"https://{site}/ajax.php"
    torrent_id = uq["torrentid"]

    release_dir = pathlib.Path(args.directory)

    headers = {"Authorization": args.api_key}
    params = {"action": "torrent", "id": torrent_id}

    r = requests.get(api_url, headers=headers, params=params)
    rj = r.json()

    current_description = rj["response"]["torrent"]["description"]

    redcurry_block = extract_redcurry_block(current_description)
    spectral_block = extract_spectral_block(current_description)
    flac_info = extract_flac_info_line(current_description)
    release_date = extract_release_date_line(current_description)
    release_url = extract_release_url_line(current_description)
    scans_block = extract_flat_block(current_description, "Scans")
    downconv_section = extract_downconv_section(current_description)
    tags_block = extract_flat_block(current_description, "Tags")
    propolis_block = extract_flat_block(current_description, "Propolis Report")

    if any(i is None for i in [spectral_block, release_url]):
        print("Error: default smoked salmon blocks missing", file=sys.stderr)
        print([i is None for i in [flac_info, release_date, release_url]])
        sys.exit(1)

    if not spectral_block or ("https://ptpimg.me" in spectral_block) or args.spectrals:
        print("Generating spectrals block")
        spectral_block = generate_spectrals_block(release_dir, args.img_api_key)

    if not flac_info or args.force:
        print("Generating flac info line")
        flac_info = generate_flac_info_line(args.directory)

    if not release_date or args.force:
        print("Generating release date line")
        release_date = generate_release_date_line(args.directory)

    if not downconv_section or args.force:
        print("Generating downconv section")
        downconv_section = generate_downconv_section(args.directory)

        if not downconv_section or args.force:
            print("No downconv information found")

    if not tags_block or args.force:
        print("Generating tags block")
        tags_block = generate_tags_block(args.directory)

    if not propolis_block or args.force:
        print("Generating propolis report block")
        propolis_block = generate_propolis_block(args.directory)
        print(propolis_block.splitlines()[-1].split("[")[0])

    tools = [
        "[url=https://github.com/smokin-salmon/smoked-salmon]smoked-salmon[/url]",
        "[url=https://gitlab.com/passelecasque/propolis]propolis[/url]",
    ]

    if downconv_section:
        tools += "[url=https://gitlab.com/beep_street/downsampler-threaded]downsampler-threaded[/url]",

    tools_joined = " | ".join(tools)
    tools_block = f"[b]Tools:[/b] {tools_joined}"

    sections = [
        redcurry_block,
        spectral_block,
        flac_info,
        release_date,
        release_url,
        scans_block,
        downconv_section,
        "",
        tags_block,
        propolis_block,
        "",
        tools_block,
    ]

    new_description = "\n".join(i for i in sections if i is not None)

    new_description = replace_text(new_description, SOURCE_ICONS)
    new_description = replace_urls(new_description)

    if current_description != new_description:
        print("Updating release description")

        data = {"release_desc": new_description}
        params = {"action": "torrentedit", "id": torrent_id}

        r = requests.post(api_url, headers=headers, params=params, data=data)

        if r.status_code != 200:
            print("Error: unable to update release description")
            print(r.status_code)
            print(r.text)
    else:
        print("Release description already up to date")


if __name__ == "__main__":
    main()
