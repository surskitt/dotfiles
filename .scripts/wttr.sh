#!/usr/bin/env bash

get_icon() {
   case "${*}" in
       *[Cc]lear*)
           echo 
           ;;
       *[Ss]unny*)
           echo 
           ;;
       *[Cc]loudy*)
           echo 杖
           ;;
       *[Oo]vercast*)
           echo 
           ;;
       *[Rr]ain*)
           echo 
           ;;
       *[Mm]ist*)
           echo 
           ;;
       *[Ss]now*)
           echo 
           ;;
       *[Tt]hunder*)
           echo 
           ;;
       *[Ff]og*)
           echo 
           ;;
       *[Dd]rizzle*)
           echo 
           ;;
       *[Hh]aze*)
           echo 
           ;;
        *)
           echo "?"
           ;;
   esac
}

notify_body() {
    humidity="${1}"
    wind="${2}"
    sunrise="${3}"
    dawn="${4}"
    sunset="${5}"
    dusk="${6}"

    l1="💧 ${humidity/\\/}"
    l2="🌬️ ${wind}"
    l3="🌅 ${sunrise%:*} (${dawn%:*})"
    l4="🌇 ${sunset%:*} (${dusk%:*})"

    printf "\n%s\n%s\n%s\n%s\n" "${l1}" "${l2}" "${l3}" "${l4}"
}

NOTIFY=false

while getopts "n" opt; do
    case "${opt}" in
        n)
            NOTIFY=true
            ;;
        ?)
            echo "Invalid options passed"
            exit 1
            ;;
    esac
done

w=$(curl -s wttr.in/?format='%c_%C_%t_%h_%w_%S_%D_%s_%d\n')

IFS="_" read -r emoji cond temp humidity wind sunrise dawn sunset dusk <<< "${w}"

icon=$(get_icon "$cond")

if $NOTIFY; then
    title="${emoji} ${cond} ${temp#+}"
    body=$(notify_body "${humidity}" "${wind}" "${sunrise}" "${dawn}" "${sunset}" "${dusk}")

    notify-send "${title}" "${body}"
else
    echo "${icon} ${temp/+/}"
fi
