-module(transpose).

-export([transpose/1, pad/1]).

transpose(M) -> t(lists:reverse(pad(lists:reverse(M)))).

t([]) -> [];
t(M) ->
    ResRow = lists:filtermap(
        fun ([]) -> false;
            (Row) -> {true, hd(Row)} end,
        M
    ),
    M2 = lists:filtermap(
        fun ([]) -> false;
            ([_]) -> false;
            (Row) -> {true, tl(Row)} end,
        M
    ),
    [ResRow | t(M2)].

% pad next up to current length
pad([]) -> [];
pad([C]) -> [C];
pad([C, N | T]) ->
    N2 = string_pad(N, length(C), $\s),
    [C | pad([N2 | T])].

string_pad(Str, Len, Char) ->
    case length(Str) < Len of
        true -> string:left(Str, Len, Char);
        false -> Str
    end.
