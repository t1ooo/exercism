-module(dominoes).

-export([can_chain/1, is_chain/3]).

can_chain([]) -> true;
can_chain(L) ->
	[{FirstN, LastN} | T] = L,
	is_chain(FirstN, T, LastN).

is_chain(PrevN, [], LastN) -> PrevN =:= LastN;
is_chain(PrevN, L, LastN) ->
	Fun = fun (X) ->
		case X of
			{PrevN, N} -> is_chain(N, L -- [X], LastN);
			{N, PrevN} -> is_chain(N, L -- [X], LastN);
			_ -> false
		end
	end,
	lists:any(Fun, L).
