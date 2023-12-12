-module(zipper).

-export([from_tree/1, left/1, new_tree/3, right/1,
	 set_left/2, set_right/2, set_value/2, to_tree/1, up/1,
	 value/1]).

new_tree(V, L, R) -> {L, V, R}.

from_tree(Tree) -> {Tree, []}.

to_tree({Curr, []}) -> Curr;
to_tree(Zipper) -> to_tree(up(Zipper)).

value({{_, V, _}, _}) -> V.

set_value({{L, _, R}, Trail}, V) ->
    {{L, V, R}, Trail}.

set_left({{_, V, R}, Trail}, L) ->
    {{L, V, R}, Trail}.

set_right({{L, V, _}, Trail}, R) ->
    {{L, V, R}, Trail}.

left({{nil, _, _}, _}) -> nil;
% add Parent node to Tail instead just Value and RightChild for ease of understanding
left({Parent={L, _, _}, Trail}) ->
    {L, [{left, Parent} | Trail]}.

right({{_, _, nil}, _}) -> nil;
right({Parent={_, _, R}, Trail}) ->
    {R, [{right, Parent} | Trail]}.

up({_, []}) -> nil;
up({Curr, [{left, _Parent={_, V, R}} | T]}) ->
    {{Curr, V, R}, T};
up({Curr, [{right, _Parent={L, V, _}} | T]}) ->
    {{L, V, Curr}, T}.
