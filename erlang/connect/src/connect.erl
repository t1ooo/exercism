-module(connect).

-export([is_winner/2, winner/1]).

winner(Board) ->
    Board2 = [filter_spaces(Row) || Row <- Board],
    select_winner([
        {fun () -> is_winner($O, Board2) end, o},
        {fun () -> is_winner($X, transpose(Board2)) end, x},
        {fun () -> true end, undefined}
    ]).

filter_spaces(Str) -> [X || X <- Str, X =/= $\s].

select_winner([{Fun, Resp} | T]) ->
    case Fun() of
        true -> Resp;
        false -> select_winner(T)
    end.

is_winner(Char, Board) ->
    FirstRow = get(1, Board),
    CharIndexes = find_indexes(Char, FirstRow),
    lists:any(
        fun (X) ->
            Visited = [{X, 1}],
            find_path(Char, Board, Visited)
        end,
        CharIndexes
    ).

find_indexes(El, List) ->
    [Index ||
        Index <- lists:seq(1, length(List)),
        lists:nth(Index, List) =:= El
    ].

% return [] if not found
get(N, L) when N < 1 orelse length(L) < N -> [];
get(N, L) -> lists:nth(N, L).

% return [] if not found
get_2d({X, Y}, M) -> get(X, get(Y, M)).

-define(MOVES, [
              {0, -1}, {+1, -1},
    {-1,  0},          {+1,  0},
    {-1, +1}, {0, +1}
]).

find_path(_, Board, [{_, Y} | _])
    when Y =:= length(Board) -> true;
find_path(Char, Board, Visited = [PrevCoord | _]) ->
    Coords = [sum(Coord, PrevCoord) || Coord <- ?MOVES],
    CoordsNotVisited = Coords -- Visited,
    Fun = fun ({X2, Y2}) ->
        case get_2d({X2, Y2}, Board) of
            Char -> find_path(Char, Board, [{X2, Y2} | Visited]);
            _ -> false
        end
    end,
    lists:any(Fun, CoordsNotVisited).

sum({A, B}, {C, D}) -> {A + C, B + D}.

transpose([[] | _]) -> [];
transpose(M) ->
    [lists:map(fun hd/1, M) | transpose(lists:map(fun tl/1, M))].
