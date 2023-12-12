:- use_module(library(yall)).

pascal(0, []) :- !.
pascal(N, R) :-
    N2 is N-1,
    numlist(0, N2, Range),
    maplist(row, Range, R).

row(Y, R) :-
    numlist(0, Y, Range),
    maplist([X, FR]>>cell(X, Y, FR), Range, R).

% y! / ( x! * (y-x)! )
cell(X, Y, R) :-
    Z is Y - X,
    maplist(factorial, [X, Y, Z], [X2, Y2, Z2]),
    R is Y2 / (X2 * Z2).

factorial(0, 1) :- !.
factorial(N, R) :-
    N > 0,
    N2 is N - 1,
    factorial(N2, R2),
    R is N * R2.