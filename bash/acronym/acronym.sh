#!/usr/bin/env bash

if (("$#" != 1)); then
    echo "Usage: ${0##*/} <string>"
    exit 1
fi

s="${1^^}"
s="${s//\'/}"
s="${s//[^A-Z]/ }"
for word in $s; do
    echo -n "${word:0:1}"
done
