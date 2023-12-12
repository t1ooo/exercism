#!/usr/bin/env bash

two_fer () {
    (( "$#" == 0 )) && name="you" || name="$1"
    echo "One for $name, one for me."
}

two_fer "$@"