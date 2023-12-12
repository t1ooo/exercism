#!/usr/bin/env bash

function is_empty() {
    [[ -z "$1" ]]
}

function is_question() {
    [[ "$1" == *"?" ]]
}

function is_yell() {
    [[ "$1" == "${1^^}" && "$1" != "${1,,}" ]]
}

str="${1//[[:space:]]/}"

if is_empty "$str"; then
    echo "Fine. Be that way!"
elif is_question "$str" && is_yell "$str"; then
    echo "Calm down, I know what I'm doing!"
elif is_question "$str"; then
    echo "Sure."
elif is_yell "$str"; then
    echo "Whoa, chill out!"
else
    echo "Whatever."
fi
