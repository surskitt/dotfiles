#!/usr/bin/env bash

if grep -q '    gaps 40' ~/.config/niri/config.kdl ; then
    sed -i 's/^    gaps 40/    gaps 0/g' ~/.config/niri/config.kdl
else
    sed -i 's/^    gaps 0/    gaps 40/g' ~/.config/niri/config.kdl
fi
