#!/bin/bash

err() { >&2 echo $@ && exit 1; }

[ $# -ne 2 -a $# -ne 3 ] && err "Usage: ${0} FILE1 FILE2 [OUTPUT_DIR]"

if ! command -v sox &> /dev/null
then
    err "Error: sox could not be found, and is required to generate spectrograms."
fi

[[ ! -e ${1} ]] && err "File or directory not found: ${1}"
[[ ! -e ${2} ]] && err "File or directory not found: ${2}"

generate_diff () {
   cmp -s "${1}" "${2}" && err "Files are bit-identical per cmp(1), no point in comparing spectrograms."

    # remove silence from front and rear
    sox "${1}" "${1}-trimmed.flac" silence 1 0.5 1% reverse silence 1 0.5 1% reverse
    sox "${2}" "${2}-trimmed.flac" silence 1 0.5 1% reverse silence 1 0.5 1% reverse

    # SoX sends output to STDERR
    TRACK1=$(sox "${1}-trimmed.flac" -n stat 2>&1)
    TRACK2=$(sox "${2}-trimmed.flac" -n stat 2>&1)

    [[ ${TRACK1} =~ 'sox FAIL' ]] && err "${TRACK1}"
    [[ ${TRACK2} =~ 'sox FAIL' ]] && err "${TRACK2}"

    if [[ $TRACK1 =~ Length[[:space:]]\(seconds\):[[:space:]]+([[:digit:]]+\.[[:digit:]]{1,2}) ]]; then
      TRACK1_LEN=${BASH_REMATCH[1]}
    fi

    if [[ $TRACK2 =~ Length[[:space:]]\(seconds\):[[:space:]]+([[:digit:]]+\.[[:digit:]]{1,2}) ]]; then
      TRACK2_LEN=${BASH_REMATCH[1]}
    fi

    if ! command -v bc &> /dev/null
    then
      [[ "${TRACK1_LEN}" == "${TRACK2_LEN}" ]]
      lendiff=$?
    else
      # squaring both sides because bc(1) does not have an abs() function
      lendiff=$(echo "(${TRACK1_LEN} - ${TRACK2_LEN})^2 > 0.005^2" | bc -l)
    fi

    if [ "$lendiff" -gt 0  ]; then
        echo "Skipping [${1}] vs. [${2}]; track lengths materially differ [${TRACK1_LEN}s vs. ${TRACK2_LEN}s] after removing leading/trailing silence."
    else
        echo -n "Generating comparison PNG ... "
        BASE1=${1##*/}
        BASE2=${2##*/}
        sox -m -v 1 "${1}-trimmed.flac" -v -1 "${2}-trimmed.flac" "specdiff-${BASE1}_vs_${BASE2}"
        if [ $? -eq 0 ]; then
          sox "specdiff-${BASE1}_vs_${BASE2}" -n remix 1 spectrogram -x 3000 -y 513 -z 120 -w Kaiser -t "${BASE1} vs. ${BASE2}" -o "specdiff-${BASE1}_vs_${BASE2}.png"
          if [ $? -eq 0 ]; then
            rm "specdiff-${BASE1}_vs_${BASE2}"
            [ -n "${3}" ] && mkdir -p "${3}" && mv "specdiff-${BASE1}_vs_${BASE2}.png" "${3}" && echo "done: $(readlink -f ${3})/specdiff-${BASE1}_vs_${BASE2}.png"
            [ $? -ne 0 ] && echo "done: specdiff-${BASE1}_vs_${BASE2}.png"
          fi
        fi
    fi
    # clean up
    rm -f "${1}-trimmed.flac" "${2}-trimmed.flac"
}

if [ -d "${1}" -a -d "${2}" ]; then
  declare -a DIR1 DIR2
  for i in {1..2}; do
    while IFS= read -r -d $'\0' file; do
      if [ ${i} -eq 1 ]; then
        DIR1+=("${file}")
      else
        DIR2+=("${file}")
      fi
    done < <(find "${!i}" -type f -iname '*.flac' -print0 | sort -z)
  done
  [[ ${#DIR1[@]} -ne ${#DIR2[@]} ]] && err "Mismatch: directories contain different number of FLACs."
  for i in "${!DIR1[@]}"; do generate_diff "${DIR1[$i]}" "${DIR2[$i]}" "${3}"; done
elif [ -f "${1}" -a -f "${2}" ]; then
  generate_diff "${1}" "${2}" "${3}"
else
  err "Mismatch: both arguments must be of consistent type: either file or directory."
fi