#!/usr/bin/env bash

good() {
    echo -e "\033[0;32m${*}\033[0m"
}

bad() {
    echo -e "\033[0;31m${*}\033[0m"
}

echo "Checking integrity"
salmon check integrity .

echo

echo "Checking MQA"
isMQA -- *.flac

echo

echo "Checking for 24 bit flac"
if metaflac --show-bps -- *.flac | grep ':24$' ; then
    bad "Error: there are 24 bit flacs"
else
    good "All flacs are 16 bit"
fi

echo

echo "Checking spectrals"
flac_specs.sh *.flac
