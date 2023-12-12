-module(series).

-export([slices/2, split/3]).

slices(Len, Series)
    when 0 < Len, Len =< length(Series) ->
    split(Len, Series, 0).

split(Len, Series, Index) ->
    H = string:slice(Series, Index, Len),
    case Index + Len < length(Series) of
      true -> [H | split(Len, Series, Index + 1)];
      false -> [H]
    end.
