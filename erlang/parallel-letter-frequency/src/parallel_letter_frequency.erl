-module(parallel_letter_frequency).

-export([dict/1]).

dict(Strs) ->
  Fun = fun(Str) -> run(self(), fun letter_frequency/1, Str) end,
  lists:map(Fun, Strs),
  Dicts = lists:map(fun recv/1, Strs),
  dicts_sum(Dicts).

dicts_sum(Dicts) ->
  Sum = fun(_, V1, V2) -> V1 + V2 end,
  Fun = fun(Dict, Acc) -> dict:merge(Sum, Dict, Acc) end,
  lists:foldl(Fun, dict:new(), Dicts).

run(Pid, Fun, Arg) ->
  spawn(fun() -> Pid ! Fun(Arg) end).

recv(_) -> receive V -> V end, V.

letter_frequency(Str) ->
  Fun = fun(Char, Dict) -> dict:update_counter(Char, 1, Dict) end,
  lists:foldl(Fun, dict:new(), Str).