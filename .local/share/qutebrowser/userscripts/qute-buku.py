#!/usr/bin/env python

import sys
import os
import buku

bukudb = buku.BukuDb()

fifo = os.getenv('QUTE_FIFO')
url = os.getenv('QUTE_URL')
title = os.getenv('QUTE_TITLE')

if len(sys.argv) > 1:
    taglist = ',{},'.format(sys.argv[1])
else:
    taglist = None

bukudb.add_rec(url, title_in=title, fetch=False, tags_in=taglist)

with open(fifo, 'w') as qp:
    qp.write(f'jseval "{url} saved to buku"')
