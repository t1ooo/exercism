-module(bob).

-export([response/1]).

response(Str) ->
    select_response(string:trim(Str), [
        {fun is_empty/1, "Fine. Be that way!"},
        {fun is_yell_question/1, "Calm down, I know what I'm doing!"},
        {fun is_question/1, "Sure."},
        {fun is_yell/1, "Whoa, chill out!"},
        {fun is_anything/1, "Whatever."}
    ]).

select_response(Question, [{Fun, Resp} | T]) ->
    case Fun(Question) of
      true -> Resp;
      false -> select_response(Question, T)
    end.

is_yell_question(Str) ->
    is_question(Str) andalso is_yell(Str).

is_question(Str) -> lists:last(Str) =:= $?.

is_yell(Str) ->
    string:to_upper(Str) =:= Str andalso
    string:to_lower(Str) =/= Str.

is_empty(Str) -> Str =:= "".

is_anything(_) -> true.
