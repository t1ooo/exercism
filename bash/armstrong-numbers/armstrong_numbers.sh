#!/usr/bin/env bash

if (("$#" != 1)) || [[ "$1" =~ [^0-9] ]]; then
    echo "Usage: ${0##*/} <number>"
    exit 1
fi

num="$1"
len="${#num}"
sum=0

for ((i = 0; i < len; i++)); do
    digit="${num:i:1}"
    ((sum += digit ** len))
done

((num == sum)) && echo "true" || echo "false"
