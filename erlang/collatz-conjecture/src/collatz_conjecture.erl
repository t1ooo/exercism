-module(collatz_conjecture).

-export([steps/1]).

steps(N) -> steps(N, 0).

steps(1, Counter) -> Counter;
steps(N, _) when N =< 0 -> erlang:error(badarg);
steps(N, Counter) when N rem 2 =:= 0 -> steps(N div 2, Counter + 1);
steps(N, Counter) -> steps(3 * N + 1, Counter + 1).