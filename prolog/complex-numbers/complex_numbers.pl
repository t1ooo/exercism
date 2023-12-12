real((A, _), R) :-
    R = A.

imaginary((_, B), R) :-
    R = B.

conjugate((A, B), (C, D)) :-
    C = A,
    D is B * -1.

abs((A, B), R) :-
    R is round(sqrt(A ^ 2 + B ^ 2)).

add((A, B), (C, D), (E, F)) :-
    E is A + C,
    F is B + D.

sub((A, B), (C, D), (E, F)) :-
    E is A - C,
    F is B - D.

mul((A, B), (C, D), (E, F)) :-
    E is A * C - B * D,
    F is B * C + A * D.

div((A, B), (C, D), (E, F)) :-
    E is (A * C + B * D) / (C ^ 2 + D ^ 2),
    F is (B * C - A * D) / (C ^ 2 + D ^ 2).