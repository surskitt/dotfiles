#!/usr/bin/env python

import os
import glob
import collections
import datetime
import pathlib

import mutagen.flac
import mutagen.oggopus
import rich
import rich.console
import rich.table
import humanize

MANUAL_TAG_ORDER = [
    "tracknumber",
    "albumartist",
    "artist",
    "title",
    "album",
    "date",
    "tracktotal",
    "genre",
    "label",
    "upc",
]

ALBUM_TAG_IGNORE = [
    "discnumber",
    "metadata_block_picture",
]

TRACK_TAG_IGNORE = [
    "lyrics",
    "unsyncedlyrics",
    "acoustid_fingerprint",
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

flacs_fns = [(i, mutagen.flac.FLAC(i)) for i in sorted(glob.glob("**/*.flac", recursive=True))]
flacs = [i[1] for i in flacs_fns]

opus_fns = [(i, mutagen.oggopus.OggOpus(i)) for i in sorted(glob.glob("**/*.opus", recursive=True))]
opus = [i[1] for i in opus_fns]

audio_fns = flacs_fns + opus_fns
audios = flacs + opus

tags = {k for i in audios for k in i.tags.keys()}

album_tags = {}
for tag in tags:
    values = [str(sorted(i.get(tag, []))) for i in audios]

    counter = collections.Counter(values)

    if len(counter.keys()) == 1:
        album_tags[tag] = audios[0].get(tag)

album_tag_ordering = [i for i in MANUAL_TAG_ORDER if i in album_tags]
album_tag_ordering += sorted([i for i in album_tags if i not in album_tag_ordering+ALBUM_TAG_IGNORE])

console = rich.console.Console()

album_table = rich.table.Table("Tag", "Value", title="Album tags", **TABLE_STYLE)

for tag in album_tag_ordering:
    if not (val := album_tags.get(tag)):
        continue

    album_table.add_row(tag.upper(), "\n".join(val))

console.print(album_table)

track_tags = [i for i in tags if i not in album_tags]

track_tag_ordering = [i for i in MANUAL_TAG_ORDER if i in track_tags]
track_tag_ordering += sorted([i for i in track_tags if i not in track_tag_ordering+TRACK_TAG_IGNORE])
track_tag_ordering = [i.upper() for i in track_tag_ordering]

track_table = rich.table.Table(*track_tag_ordering, title="Track tags", **TABLE_STYLE)

for audio in audios:
    columns = ["\n".join(audio.get(tag, ["-"])) for tag in track_tag_ordering]
    track_table.add_row(*columns)

console.print(track_table)

stream_table = rich.table.Table("Filename", "Length", "Bit Depth", "Sample Rate", title="Stream Info", **TABLE_STYLE)

for audio in audio_fns:
    fn = audio[0]

    streaminfo = audio[1].info

    td = datetime.timedelta(seconds=int(streaminfo.length))
    length = str(td)

    if streaminfo.length < 3600:
        length = str(td)[-5:]

    if hasattr(streaminfo, "bits_per_sample"):
        bit_depth_colour = BIT_DEPTH_COLOURS.get(streaminfo.bits_per_sample, BIT_DEPTH_COLOUR_DEFAULT)
        bit_depth = f"[{bit_depth_colour}]{streaminfo.bits_per_sample}"
    else:
        bit_depth = "-"

    if hasattr(streaminfo, "sample_rate"):
        sample_rate_colour = SAMPLE_RATE_COLOURS.get(streaminfo.sample_rate, SAMPLE_RATE_COLOUR_DEFAULT)
        sample_rate = f"[{sample_rate_colour}]{streaminfo.sample_rate}"
    else:
        sample_rate = "-"

    stream_table.add_row(fn, length, bit_depth, sample_rate)

# total_length = sum(audio[1].info.length for i in audio_fns)
# total_size = sum(pathlib.Path(i[0]).stat().st_size for i in audio_fns)

console.print(stream_table)

files_table = rich.table.Table("Filename", "Size", title="Extra files", **TABLE_STYLE)

for i in sorted(glob.glob("**/*", recursive=True)):
    if any(i.endswith(j) for j in [".flac", ".opus"]):
        continue

    filesize = humanize.naturalsize(pathlib.Path(i).stat().st_size, binary=True)

    files_table.add_row(i, filesize)

console.print(files_table)
