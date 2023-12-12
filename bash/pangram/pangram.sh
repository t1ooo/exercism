#!/usr/bin/env bash

function is_pangram() {
    local str="${1,,}"
    for ch in {a..z}; do
        if [[ "$str" != *"$ch"* ]]; then
            echo "false"
            return
        fi
    done
    echo "true"
}

if (("$#" != 1)); then
    echo "Usage: ${0##*/} <sentence>"
    exit 1
fi

is_pangram "$1"
