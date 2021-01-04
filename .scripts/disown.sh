#!/usr/bin/env bash

nohup ${@} > /dev/null 2>&1 & sleep .2 && disown
