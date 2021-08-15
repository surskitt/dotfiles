#!/bin/sh
case "$1" in
    lock)
        light-locker-command -l
        ;;
    logout)
        pre_exit
        bspc quit
        ;;
    suspend)
        systemctl suspend
        ;;
    hibernate)
        systemctl hibernate
        ;;
    reboot)
        pre_exit
        systemctl reboot
        ;;
    shutdown)
        pre_exit
        systemctl poweroff
        ;;
    *)
        echo "Usage: $0 {lock|logout|suspend|hibernate|reboot|shutdown}"
        exit 2
esac

exit 0
