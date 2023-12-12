triangle(A, B, C, Type) :-
    triangle_inequality(A, B, C),
    (
        equilateral(A, B, C), Type = "equilateral", !;
        isosceles(A, B, C), Type = "isosceles", !;
        scalene(A, B, C), Type = "scalene"
    ).

equilateral(Side, Side, Side).

isosceles(_, Side, Side) :- !.
isosceles(Side, _, Side) :- !.
isosceles(Side, Side, _) :- !.

scalene(A, B, C) :- \+ isosceles(A,B, C).

% |a-b| < c < a+b
triangle_inequality(A, B, C) :-
    abs(A-B) < C,
    C < A + B.