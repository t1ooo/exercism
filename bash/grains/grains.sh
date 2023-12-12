#!/usr/bin/env bash

function number_of_grains() {
    printf "%llu\n" $((2 ** ($1 - 1)))
}

function total_number_of_grains() {
    printf "%llu\n" $(((2 ** 64) - 1))
}

if [[ "$1" == "total" ]]; then
    total_number_of_grains
elif ((1 <= $1 && $1 <= 64)); then
    number_of_grains "$1"
else
    echo "Error: invalid input"
    exit 1
fi
