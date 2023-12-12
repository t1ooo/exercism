%% Based on canonical data version 1.1.0
%% https://github.com/exercism/problem-specifications/raw/master/exercises/transpose/canonical-data.json
%% This file is automatically generated from the exercises canonical data.

-module(transpose_tests).

-include_lib("erl_exercism/include/exercism.hrl").
-include_lib("eunit/include/eunit.hrl").




'1_empty_string_test'() ->
    Input=[

    ],
    Expected=[

    ],
    ?assertEqual(Expected, transpose:transpose(Input)).

'2_two_characters_in_a_row_test'() ->
    Input=[
        "A1"
    ],
    Expected=[
        "A",
        "1"
    ],
    ?assertEqual(Expected, transpose:transpose(Input)).

'3_two_characters_in_a_column_test'() ->
    Input=[
        "A",
        "1"
    ],
    Expected=[
        "A1"
    ],
    ?assertEqual(Expected, transpose:transpose(Input)).

'4_simple_test'() ->
    Input=[
        "ABC",
        "123"
    ],
    Expected=[
        "A1",
        "B2",
        "C3"
    ],
    ?assertEqual(Expected, transpose:transpose(Input)).

'5_single_line_test'() ->
    Input=[
        "Single line."
    ],
    Expected=[
        "S",
        "i",
        "n",
        "g",
        "l",
        "e",
        " ",
        "l",
        "i",
        "n",
        "e",
        "."
    ],
    ?assertEqual(Expected, transpose:transpose(Input)).

'6_first_line_longer_than_second_line_test'() ->
    Input=[
        "The fourth line.",
        "The fifth line."
    ],
    Expected=[
        "TT",
        "hh",
        "ee",
        "  ",
        "ff",
        "oi",
        "uf",
        "rt",
        "th",
        "h ",
        " l",
        "li",
        "in",
        "ne",
        "e.",
        "."
    ],
    ?assertEqual(Expected, transpose:transpose(Input)).

'7_second_line_longer_than_first_line_test'() ->
    Input=["The first line.", "The second line."],
    Expected=[
        "TT",
        "hh",
        "ee",
        "  ",
        "fs",
        "ie",
        "rc",
        "so",
        "tn",
        " d",
        "l ",
        "il",
        "ni",
        "en",
        ".e",
        " ."
    ],
    ?assertEqual(Expected, transpose:transpose(Input)).

'8_mixed_line_length_test'() ->
    Input=[
        "The longest line.",
        "A long line.",
        "A longer line.",
        "A line."
    ],
    Expected=[
        "TAAA",
        "h   ",
        "elll",
        " ooi",
        "lnnn",
        "ogge",
        "n e.",
        "glr",
        "ei ",
        "snl",
        "tei",
        " .n",
        "l e",
        "i .",
        "n",
        "e",
        "."
    ],
    ?assertEqual(Expected, transpose:transpose(Input)).

'9_square_test'() ->
    Input=[
        "HEART",
        "EMBER",
        "ABUSE",
        "RESIN",
        "TREND"
    ],
    Expected=[
        "HEART",
        "EMBER",
        "ABUSE",
        "RESIN",
        "TREND"
    ],
    ?assertEqual(Expected, transpose:transpose(Input)).

'10_rectangle_test'() ->
    Input=[
        "FRACTURE",
        "OUTLINED",
        "BLOOMING",
        "SEPTETTE"
    ],
    Expected=[
        "FOBS",
        "RULE",
        "ATOP",
        "CLOT",
        "TIME",
        "UNIT",
        "RENT",
        "EDGE"
    ],
    ?assertEqual(Expected, transpose:transpose(Input)).

'11_triangle_test'() ->
    Input=[
        "T",
        "EE",
        "AAA",
        "SSSS",
        "EEEEE",
        "RRRRRR"
    ],
    Expected=[
        "TEASER",
        " EASER",
        "  ASER",
        "   SER",
        "    ER",
        "     R"
    ],
    ?assertEqual(Expected, transpose:transpose(Input)).
