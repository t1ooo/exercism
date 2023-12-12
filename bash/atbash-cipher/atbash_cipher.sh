#!/usr/bin/env bash

ord() {
    printf "%d" "'$1"
}

chr() {
    printf "\\$(printf '%03o' "$1")"
}

encode_char() {
    local ch="${1,,}"
    if [[ "$ch" =~ [0-9] ]]; then
        echo "$1"
    elif [[ "$ch" =~ [a-z] ]]; then
        local code=$(($(ord "a") + 25 - ($(ord "$ch") - $(ord "a"))))
        chr "$code"
    else
        echo ""
    fi
}

encode() {
    local str="$1"
    for ((i = 0; i < ${#str}; i++)); do
        echo -n "$(encode_char "${str:i:1}")"
    done
}

format() {
    local str="$1"
    local len=5
    for ((i = 0; i < ${#str}; i += len)); do
        echo -n "${str:i:len}"
        if ((i + len < ${#str})); then
            echo -n " "
        fi
    done
}

help() {
    echo "Usage: ${0##*/} <command> <string>"
}

if (($# != 2)); then
    help
    exit 1
fi

case "$1" in
encode)
    format "$(encode "$2")"
    ;;
decode)
    encode "$2"
    ;;
*)
    help
    exit 1
    ;;
esac
