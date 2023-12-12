%% Based on canonical data version 1.2.1.2
%% Generated with 'testgen v0.1.0'
%% https://github.com/exercism/problem-specifications/raw/d94e348371af1d3efd8728a5b4e71d1b3d95c37e/exercises/collatz-conjecture/canonical-data.json
%% This file is automatically generated from the exercises canonical data.

-module(collatz_conjecture_tests).

-include_lib("erl_exercism/include/exercism.hrl").
-include_lib("eunit/include/eunit.hrl").




'1_zero_steps_for_one_test_'() ->
    {"zero steps for one",
     ?_assertMatch(0, collatz_conjecture:steps(1))}.

'2_divide_if_even_test_'() ->
    {"divide if even",
     ?_assertMatch(4, collatz_conjecture:steps(16))}.

'3_even_and_odd_steps_test_'() ->
    {"even and odd steps",
     ?_assertMatch(9, collatz_conjecture:steps(12))}.

'4_large_number_of_even_and_odd_steps_test_'() ->
    {"large number of even and odd steps",
     ?_assertMatch(152, collatz_conjecture:steps(1000000))}.

'5_zero_is_an_error_test_'() ->
    {"zero is an error",
     ?_assertError(badarg, collatz_conjecture:steps(0))}.

'6_negative_value_is_an_error_test_'() ->
    {"negative value is an error",
     ?_assertError(badarg, collatz_conjecture:steps(-15))}.
