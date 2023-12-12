-module(raindrops).

-export([convert/1]).

convert(N) -> convert(N, [{N rem 3, "Pling"}, {N rem 5, "Plang"}, {N rem 7, "Plong"}], []).

convert(N, [{0, Drop}|T], Acc) -> convert(N, T, [Drop|Acc]);
convert(N, [_|T], Acc) -> convert(N, T, Acc);
convert(N, [], []) -> convert(N, [], [N]);
convert(_, [], Acc) -> lists:concat(lists:reverse(Acc)).
