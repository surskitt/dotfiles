#!/usr/bin/env bash

tmux display-message -p '#{window_width}x#{window_height}'
echo

mapfile -t panes < <(tmux list-panes -F '#{pane_id}')

curr_left="$(tmux display-message -p -t "${panes[0]}" '#{pane_left}')"
for pane in "${panes[@]}" ; do
    new_left="$(tmux display-message -p -t "${pane}" '#{pane_left}')"
    if [[ "${new_left}" != "${curr_left}" ]] ; then
        echo
    fi
    curr_left="${new_left}"

    tmux display-message -p -t "${pane}" '#{pane_width}x#{pane_height}'
done
