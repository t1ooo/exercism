#!/usr/bin/env bash

reverse() {
    local s=""
    for ((i = 0; i < "${#1}"; i++)); do
        s="${1:i:1}$s"
    done
    echo "$s"
}

num="${1// /}"
if (("${#num}" < 2)) || [[ "$num" =~ [^0-9] ]]; then
    echo false
    exit 0
fi

num=$(reverse "$num")
sum=0
for ((i = 0; i < "${#num}"; i++)); do
    d="${num:i:1}"
    if ((i % 2 == 1)); then
        ((d = d < 5 ? (d * 2) : (d * 2 - 9)))
    fi
    ((sum += d))
done

((sum % 10 == 0)) && echo true || echo false
