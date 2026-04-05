#!/usr/bin/env bash

echo "[size=3][b]Tracklist[/b][/size]"
# echo "[b]Tracklist[/b]"
echo

# echo -n "[size=2]"

total=0

for i in *.flac ; do
    json="$(mediainfo --Output=JSON "${i}")"

    no="$(jq -r '.media.track[0].Track_Position' <<< "${json}")"
    printf -v no "%02d" "${no}"

    title="$(jq -r '.media.track[0].Title' <<< "${json}")"

    duration="$(jq -r '.media.track[0].Duration' <<< "${json}")"
    duration="${duration%.*}"

    total="$((total+duration))"

    minutes="$(echo "${duration}/60" | bc)"
    printf -v minutes "%02d" "${minutes}"
    seconds="$(echo "${duration}%60" | bc)"
    printf -v seconds "%02d" "${seconds}"

    echo "[b]${no}[/b]. [plain]${title}[/plain] [i][${minutes}:${seconds}][/i]"
    # echo "${no}. ${title} [${minutes}:${seconds}]"
done

output_time=

if [[ "${total}" -gt 3600 ]] ; then
    hours="$(echo "${total}/3600" | bc)"
    output_time="${hours}:"

    total="$((total-3600))"
fi

minutes="$(echo "${total}/60" | bc)"
printf -v minutes "%02d" "${minutes}"
output_time="${output_time}${minutes}:"

seconds="$(echo "${total}%60" | bc)"
printf -v seconds "%02d" "${seconds}"
output_time="${output_time}${seconds}"

echo
echo "——————————"
# echo "Total time: ${minutes}:${seconds}"
echo "Total time: [i]${output_time}[/i]"
