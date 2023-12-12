sum_of_multiples(_, 0, 0).
sum_of_multiples(Factors, Limit, Res) :-
    Limit2 is Limit - 1,
    sum_of_multiples(Factors, Limit2, Res2),
    (multiples(Factors, Limit2),
        Res is Res2 + Limit2;
        Res is Res2
    ), !.

multiples([], _) :- false.
multiples([Factor|T], N) :-
    (N rem Factor =:= 0,
        true;
        multiples(T, N)
    ), !.