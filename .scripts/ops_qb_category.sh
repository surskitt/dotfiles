#!/usr/bin/env bash

qb_tag.py uploads ${@}

qb_category.py "music/sortable" ${@}
