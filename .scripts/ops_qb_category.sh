#!/usr/bin/env bash

qb_search.py -q "${PWD##*/}" | xargs qb_tag.py uploads

qb_search.py -c uploads -q "${PWD##*/}" | xargs qb_category.py "music/unsorted"
