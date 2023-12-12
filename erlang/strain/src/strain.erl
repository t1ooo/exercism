-module(strain).

-export([discard/2, keep/2]).

keep(Fn, List) -> keep(Fn, List, []).

keep(_, [], Acc) -> lists:reverse(Acc);
keep(Fn, [H | T], Acc) ->
    case Fn(H) of
        true -> keep(Fn, T, [H | Acc]);
        false -> keep(Fn, T, Acc)
    end.

discard(Fn, List) ->
    keep(fun (X) -> not Fn(X) end, List).
