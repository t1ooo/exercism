-module(custom_set).

-export([add/2, contains/2, difference/2, disjoint/2,
	 empty/1, equal/2, from_list/1, intersection/2, subset/2,
	 union/2]).

add(Elem, Set) -> [Elem | lists:delete(Elem, Set)].

contains(Elem, Set) -> lists:member(Elem, Set).

difference(Set1, Set2) ->
    lists:filter(complement(contains_fn(Set2)), Set1).

disjoint(Set1, Set2) -> intersection(Set1, Set2) =:= [].

empty(Set) -> Set =:= [].

equal(Set1, Set2) ->
    lists:sort(Set1) =:= lists:sort(Set2).

from_list(List) -> List.

intersection(Set1, Set2) ->
    lists:filter(contains_fn(Set2), Set1).

subset(Set1, Set2) ->
    lists:all(contains_fn(Set2), Set1).

union(Set1, Set2) -> Set1 ++ difference(Set2, Set1).

contains_fn(Set) ->
    fun (Elem) -> contains(Elem, Set) end.

complement(Fn) -> fun (Args) -> not Fn(Args) end.
