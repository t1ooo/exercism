:- use_module(library(dcg/basics)).

wordy(Question, Answer) :-
    string_codes(Question, Codes),
    phrase(parse(FirstNum, OpNums), Codes, []),
    foldl(calc, OpNums, FirstNum, Answer).

calc(("+", A), B, C) :- C is B + A.
calc(("-", A), B, C) :- C is B - A.
calc(("*", A), B, C) :- C is B * A.
calc(("/", A), B, C) :- C is B / A.

parse(FirstNum, OpNums) --> question, first_num(FirstNum), op_nums(OpNums), "?", !.

question --> "What".
question --> {throw(error(unknown_operation_error, _))}.

first_num(Num) --> " ", "is", " ", number(Num).
first_num(_) --> " ", "is", {throw(error(syntax_error, _))}.

op_nums([]) --> [].
op_nums([H|T]) --> op_num(H), op_nums(T).

op_num((Op, Num)) --> " ", operator(Op), " ", number(Num).
op_num((Op, _)) --> " ", operator(Op), {throw(error(syntax_error, _))}.

operator("+") --> "plus", !.
operator("-") --> "minus", !.
operator("*") --> "multiplied by", !.
operator("/") --> "divided by", !.
operator(N) --> number(N), {throw(error(syntax_error, _))}.
operator(_) --> {throw(error(unknown_operation_error, _))}.