-module(bracket_push).

-export([is_paired/1]).

-define(B1, $[).
-define(B2, $]).

-define(R1, $().
-define(R2, $)).

-define(C1, ${).
-define(C2, $}).

is_paired(String) -> is_paired(String, []).

is_paired([], Stack) -> Stack =:= [];

% if char == '[' -> push ']' to stack
is_paired([?B1 | T], Stack) -> is_paired(T, [?B2 | Stack]);
% if char == ']' -> pop from stack and check that popped == ']'
is_paired([?B2 | T], [?B2 | Stack]) -> is_paired(T, Stack); 
% if char == ']' and popped != ']' -> return false
is_paired([?B2 | _], _) -> false;                           

is_paired([?R1 | T], Stack) -> is_paired(T, [?R2 | Stack]);
is_paired([?R2 | T], [?R2 | Stack]) -> is_paired(T, Stack);
is_paired([?R2 | _], _) -> false;

is_paired([?C1 | T], Stack) -> is_paired(T, [?C2 | Stack]);
is_paired([?C2 | T], [?C2 | Stack]) -> is_paired(T, Stack);
is_paired([?C2 | _], _) -> false;

% skip any not bracket char
is_paired([_ | T], Stack) -> is_paired(T, Stack).
