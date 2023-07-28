#!/usr/bin/env bash

UB_PID_FILE="/tmp/.$(uuidgen)"
ueberzugpp layer --no-stdin --silent --use-escape-codes --pid-file $UB_PID_FILE
UB_PID=$(cat $UB_PID_FILE)
SOCKET=/tmp/ueberzugpp-$UB_PID.socket

playerctl -p ShairportSync metadata --format "{{ mpris:artUrl }}" --follow \
    | while read u; do ueberzugpp cmd -s "${SOCKET}" -i playerctl -a add -x 0 -y 0 --max-width 300 --max-height 300 -f "${u#file://}" ; done &

ncfg=$(grep -v "^song_list_format" ~/.ncmpcpp/config)
lf=$(grep "^song_list_format" ~/.ncmpcpp/config|head -1|sed 's/= "/= "                                            /')

ncmpcpp -c <(echo -e "$ncfg\n$lf")

ueberzugpp cmd -s $SOCKET -a exit
