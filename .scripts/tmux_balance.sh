#!/usr/bin/env bash

abs() {
    num="${1}"

    if [[ "${num}" -lt 0 ]] ; then
        echo "$(( num * -1 ))"
    else
        echo "${num}"
    fi
}

set_width() {
    pane="${1}"
    new_width="${2}"

    pane_width="$(tmux display-message -p -t "${pane}" '#{pane_width}')"
    width_difference="$(( pane_width - new_width ))"

    if [[ "${width_difference}" -eq 0 ]] ; then
        return
    fi

    width_difference="$(abs "${width_difference}")"

    if [[ "${pane_width}" -lt "${new_width}" ]] ; then
        tmux resize-pane -t "${pane}" -R "${width_difference}"
    else
        tmux resize-pane -t "${pane}" -L "${width_difference}"
    fi
}

set_height() {
    pane="${1}"
    new_height="${2}"

    pane_height="$(tmux display-message -p -t "${pane}" '#{pane_height}')"
    height_difference="$(( pane_height - new_height ))"

    if [[ "${height_difference}" -eq 0 ]] ; then
        return
    fi

    height_difference="$(abs "${height_difference}")"

    if [[ "${pane_height}" -lt "${new_height}" ]] ; then
        tmux resize-pane -t "${pane}" -D "${height_difference}"
    else
        tmux resize-pane -t "${pane}" -U "${height_difference}"
    fi
}

mapfile -t panes < <(tmux list-panes -F '#{pane_id}')

top_panes=()
for pane in "${panes[@]}" ; do
    pane_top="$(tmux display-message -p -t "${pane}" '#{pane_top}')"
    if [[ "${pane_top}" -eq 0 ]] ; then
        top_panes+=("${pane}")
    fi
done

column_count="${#top_panes[@]}"

window_width="$(tmux display-message -p '#{window_width}')"
panes_width="$(( window_width - column_count + 1 ))"
new_column_width="$(( panes_width / column_count ))"
width_remainder="$(( panes_width % column_count ))"

for i in "${!top_panes[@]}" ; do
    pane="${top_panes[$i]}"

    pane_right="$(tmux display-message -p -t "${pane}" '#{pane_right}')"

    if [[ "${i}" -lt "${width_remainder}" ]] ; then
        pad=1
    else
        pad=0
    fi

    if [[ "$(( pane_right + 1 ))" -ne "${window_width}" ]] ; then
        set_width "${pane}" "$(( new_column_width + pad ))"
    fi
done

window_height="$(tmux display-message -p '#{window_height}')"

for top_pane in "${top_panes[@]}" ; do
    pane_left="$(tmux display-message -p -t "${top_pane}" '#{pane_left}')"

    column_panes=()
    for pane in "${panes[@]}" ; do
        current_pane_left="$(tmux display-message -p -t "${pane}" '#{pane_left}')"
        if [[ "${current_pane_left}" == "${pane_left}" ]] ; then
            column_panes+=("${pane}")
        fi
    done

    row_count="${#column_panes[@]}"
    panes_height="$(( window_height - row_count + 1 ))"
    new_row_height="$(( panes_height / row_count ))"
    height_remainder="$(( panes_height % row_count ))"

    for i in "${!column_panes[@]}" ; do
        pane="${column_panes[$i]}"

        pane_bottom="$(tmux display-message -p -t "${pane}" '#{pane_bottom}')"

        if [[ "${i}" -lt "${height_remainder}" ]] ; then
            pad=1
        else
            pad=0
        fi

        if [[ "$(( pane_bottom + 1))" -ne "${window_height}" ]] ; then
            set_height "${pane}" "$(( new_row_height + pad ))"
        fi
    done
done
