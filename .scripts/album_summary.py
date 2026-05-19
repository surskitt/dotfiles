#!/usr/bin/env python

import collections
import datetime
import glob
import os
import pathlib
import sys

import humanize
import mutagen.flac
import mutagen.mp3
import mutagen.mp4
import mutagen.oggopus
import rich
import rich.console
import rich.markup
import rich.table

MANUAL_TAG_ORDER = [
    "TRACKNUMBER",
    "ALBUMARTIST",
    "ARTIST",
    "TITLE",
    "ALBUM",
    "DATE",
    "TRACKTOTAL",
    "GENRE",
    "LABEL",
    "UPC",
]

TAG_ALIASES = {
    "trkn": "TRACKNUMBER",
    "\xa9nam": "TITLE",
    "\xa9alb": "ALBUM",
    "disk": "DISCNUMBER",
    "\xa9ART": "ARTIST",
    "aART": "ALBUMARTIST",
    "\xa9wrt": "COMPOSER",
    "\xa9day": "DATE",
    "\xa9gen": "GENRE",
    "----:com.apple.iTunes:UPC": "UPC",
    "----:com.apple.iTunes:ISRC": "ISRC",
    "cprt": "COPYRIGHT",
    "\xa9pub": "LABEL",
    "TALB": "ALBUM",
    "TCON": "GENRE",
    "TDRC": "DATE",
    "TPE1": "ARTIST",
    "TRCK": "TRACKNUMBER",
    "TIT2": "TITLE",
    "TXXX:UPC": "UPC",
}

TAG_IGNORE = [
    "----:com.apple.iTunes:RELEASETIME",
    "----:com.apple.iTunes:PERFORMER",
    "covr",
    "soar",
    "soal",
    "\xa9lyr",
    "atID",
    "soco",
    "soaa",
    "plID",
    "sonm",
    "covr",
    "TENC",
    "TXXX:Encoded by",
    "TSSE",
    "MCDI",
]

ALBUM_TAG_IGNORE = [
    "DISCNUMBER",
    "DISCTOTAL",
    "METADATA_BLOCK_PICTURE",
    "TXXX:TOTALDISCS",
    "LYRICS",
]

TRACK_TAG_IGNORE = [
    "LYRICS",
    "UNSYNCEDLYRICS",
    "ACOUSTID_FINGERPRINT",
]

TABLE_STYLE = {
    "box": rich.box.ROUNDED,
    "style": "blue",
    "row_styles": ["on black", ""],
}

BIT_DEPTH_COLOURS = {
    16: "green",
    24: "yellow",
}

BIT_DEPTH_COLOUR_DEFAULT = "magenta"

SAMPLE_RATE_COLOURS = {
    44100: "yellow",
    48000: "green",
}

SAMPLE_RATE_COLOUR_DEFAULT = "magenta"

print(os.getcwd())
print()

flacs_fns = [
    (i, mutagen.flac.FLAC(i)) for i in sorted(glob.glob("**/*.flac", recursive=True))
]
flacs = [i[1] for i in flacs_fns]

opus_fns = [
    (i, mutagen.oggopus.OggOpus(i))
    for i in sorted(glob.glob("**/*.opus", recursive=True))
]
opus = [i[1] for i in opus_fns]

m4a_fns = [
    (i, mutagen.mp4.MP4(i)) for i in sorted(glob.glob("**/*.m4a", recursive=True))
]
m4as = [i[1] for i in m4a_fns]

mp3_fns = [
    (i, mutagen.mp3.MP3(i)) for i in sorted(glob.glob("**/*.mp3", recursive=True))
]
mp3s = [i[1] for i in mp3_fns]

audio_fns = flacs_fns + opus_fns + m4a_fns + mp3_fns
audios = flacs + opus + m4as + mp3s


def tag_filter(t):
    if t in TAG_IGNORE:
        return False
    if any(t.startswith(i) for i in ["COMM:", "APIC:", "PRIV:"]):
        return False
    return True


tag_names = {
    TAG_ALIASES.get(k, k).upper()
    for i in audios
    for k in i.tags.keys()
    if tag_filter(k)
}


def process_tag_values(v):
    def p(vv):
        if type(vv) == tuple:
            vv = "/".join(str(i) for i in vv)
        if type(vv) == mutagen.mp4.MP4FreeForm:
            vv = vv.decode("utf-8")
        if type(vv) == int:
            vv = str(vv)
        return vv

    return [p(vv) for vv in v]


tags = [
    {
        TAG_ALIASES.get(k, k).upper(): process_tag_values(v)
        for k, v in i.tags.items()
        if tag_filter(k)
    }
    for i in audios
]

album_tags = {}
for tag in tag_names:
    values = [str(sorted(i.get(tag, []))) for i in tags]

    counter = collections.Counter(values)

    if len(counter.keys()) == 1:
        album_tags[tag] = tags[0].get(tag)

album_tag_ordering = [i for i in MANUAL_TAG_ORDER if i in album_tags]
album_tag_ordering += sorted(
    [i for i in album_tags if i not in album_tag_ordering + ALBUM_TAG_IGNORE]
)

console = rich.console.Console()

album_table = rich.table.Table("Tag", "Value", title="Album tags", **TABLE_STYLE)

for tag in album_tag_ordering:
    if not (val := album_tags.get(tag)):
        continue

    album_table.add_row(tag.upper(), rich.markup.escape("\n".join(str(i) for i in val)))

console.print(album_table)

track_tags = [i for i in tag_names if TAG_ALIASES.get(i, i) not in album_tags]

track_tag_ordering = [i for i in MANUAL_TAG_ORDER if i in track_tags]
track_tag_ordering += sorted(
    [i for i in track_tags if i not in track_tag_ordering + TRACK_TAG_IGNORE]
)
track_tag_ordering = [i.upper() for i in track_tag_ordering]

track_table = rich.table.Table(*track_tag_ordering, title="Track tags", **TABLE_STYLE)

for t in tags:
    columns = [
        rich.markup.escape("\n".join(t.get(tag, ["-"]))) for tag in track_tag_ordering
    ]
    track_table.add_row(*columns)

console.print(track_table)

stream_table = rich.table.Table(
    "Filename", "Length", "Bit Depth", "Sample Rate", title="Stream Info", **TABLE_STYLE
)

for audio in audio_fns:
    fn = rich.markup.escape(audio[0])

    streaminfo = audio[1].info

    td = datetime.timedelta(seconds=int(streaminfo.length))
    length = str(td)

    if streaminfo.length < 3600:
        length = str(td)[-5:]

    if hasattr(streaminfo, "bits_per_sample"):
        bit_depth_colour = BIT_DEPTH_COLOURS.get(
            streaminfo.bits_per_sample, BIT_DEPTH_COLOUR_DEFAULT
        )
        bit_depth = f"[{bit_depth_colour}]{streaminfo.bits_per_sample}"
    else:
        bit_depth = "-"

    if hasattr(streaminfo, "sample_rate"):
        sample_rate_colour = SAMPLE_RATE_COLOURS.get(
            streaminfo.sample_rate, SAMPLE_RATE_COLOUR_DEFAULT
        )
        sample_rate = f"[{sample_rate_colour}]{streaminfo.sample_rate}"
    else:
        sample_rate = "-"

    stream_table.add_row(fn, length, bit_depth, sample_rate)

console.print(stream_table)

files_table = rich.table.Table("Filename", "Size", title="Extra files", **TABLE_STYLE)

for i in sorted(glob.glob("**/*", recursive=True)):
    if any(i.endswith(j) for j in [".flac", ".opus", "m4a", "mp3"]):
        continue

    filesize = humanize.naturalsize(pathlib.Path(i).stat().st_size, binary=True)

    files_table.add_row(i, filesize)

console.print(files_table)
