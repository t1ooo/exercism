can_chain([]) :- !.
can_chain(Pieces) :-
    [(First,_)|_] = Pieces,
    chain(First, Pieces, First).

chain(First, [], First).
chain(Curr, List, First) :-
    select((Curr, Next), List, List2),
    chain(Next, List2, First), !.
chain(Curr, List, First) :-
    select((Next, Curr), List, List2),
    chain(Next, List2, First).