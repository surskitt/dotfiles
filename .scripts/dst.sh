#!/usr/bin/env bash

downsampler-threaded.sh .

mkdir ../dst

# ds_dir="$(ls -d resampled-16-*)"

# for i in * ; do
    # if [[ "${i}" != *.flac ]] ; then
    #     echo "Copying ${i}"
    #     cp "${i}" "${ds_dir}"/
    # fi
# done

find . -maxdepth 1 -type f \! -iname '*.flac' | while read -r f ; do
  cp "${f}" ../dst/
done

# mv "${ds_dir}" ..
mv */*.flac ../dst
ops_dir_rename.sh ../dst
