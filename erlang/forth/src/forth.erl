-module(forth).

-export([evaluate/1, tokenize/1, parse/1, eval/1]).

evaluate(Instructions) ->
    S = string:to_lower(string:join(Instructions, " ")),
    T = tokenize(S),
    {P, _} = parse(T),
    eval(P).

tokenize(Strs) ->
    Rules = [{"[0-9]+", int}, {":", start_def}, {";", end_def}, {"[^0-9;:]+", word}],
    Tokens = string:split(string:lowercase(Strs), " ", all),
    [{Ident, Token} ||
        Token <- Tokens,
        {Re, Ident} <- Rules,
        match(Token, Re)
    ].

match(Str, Re) -> nomatch =/= re:run(Str, "^" ++ Re ++ "$").

parse(L) -> parse(L, [], dict:new()).
parse([], Acc, DefDict) -> {lists:reverse(Acc), DefDict};
% expand definition
parse([{start_def, _} | T], Acc, DefDict) ->
    {Def, T2} = extract_def(T),
    {DefName, DefBodyExpand} = expand_def(Def, DefDict),
    DefDict2 = dict:store(DefName, DefBodyExpand, DefDict),
    parse(T2, Acc, DefDict2);
% expand word
parse([Token = {word, _} | T], Acc, DefDict) ->
    Value = fetch_or_def(Token, DefDict, [Token]),
    parse(T, lists:reverse(Value) ++ Acc, DefDict);
 % append int
parse([Token = {int, _} | T], Acc, DefDict) ->
    parse(T, [Token | Acc], DefDict).

extract_def(L) ->
    Fun = fun ({A, _}) -> A =/= end_def end,
    {Def, [_ | L2]} = lists:splitwith(Fun, L),
    {Def, L2}.

expand_def(Def, DefDict) ->
    [Name | Body] = Def,
    must_word(Name),
    Fun = fun (X) -> fetch_or_def(X, DefDict, X) end,
    BodyExpand = lists:flatten(lists:map(Fun, Body)),
    {Name, BodyExpand}.

must_word({word, _}) -> true;
must_word(_) -> erlang:error(def_name_not_a_word).

fetch_or_def(Key, DefDict, Def) ->
    case dict:find(Key, DefDict) of
      {ok, Value} -> Value;
      error -> Def
    end.

eval(P) -> eval(P, []).
eval([], Acc) -> lists:reverse(Acc);
eval([{int, Val} | T], Acc) ->
    eval(T, [to_int(Val) | Acc]);
eval([{word, Op} | T], Acc) ->
    {Args, Acc2} = pop(arity(Op), Acc),
    R = calc(Op, lists:reverse(Args)),
    eval(T, R ++ Acc2).

to_int(S) -> {Int, _} = string:to_integer(S), Int.

arity("+") -> 2;
arity("-") -> 2;
arity("*") -> 2;
arity("/") -> 2;
arity("dup") -> 1;
arity("drop") -> 1;
arity("swap") -> 2;
arity("over") -> 2.

calc("+", [A, B]) -> [A + B];
calc("-", [A, B]) -> [A - B];
calc("*", [A, B]) -> [A * B];
calc("/", [A, B]) -> [A div B];
calc("dup", [A]) -> [A, A];
calc("drop", [_]) -> [];
calc("swap", [A, B]) -> [A, B];
calc("over", [A, B]) -> [A, B, A].

pop(N, L) when length(L) < N -> erlang:error(not_enough_numbers);
pop(N, L) -> pop(N, L, []).
pop(0, L, Acc) -> {lists:reverse(Acc), L};
pop(N, L, Acc) -> pop(N - 1, tl(L), [hd(L) | Acc]).
