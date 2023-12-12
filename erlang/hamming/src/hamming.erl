-module(hamming).

-export([distance/2]).

distance(Str1, Str2) -> distance(Str1, Str2, 0).

distance([], [], Counter) -> Counter;
distance([H | T1], [H | T2], Counter) -> distance(T1, T2, Counter);
distance([_ | T1], [_ | T2], Counter) -> distance(T1, T2, Counter + 1);
distance(_, _, _) -> {error, "left and right strands must be of equal length"}.
