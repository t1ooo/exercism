-module(leap).

-export([leap_year/1]).

leap_year(Year) ->
    is_divisible(Year, 400) orelse (is_divisible(Year,4) andalso not is_divisible(Year,100)).

is_divisible(A, B) -> A rem B == 0.
