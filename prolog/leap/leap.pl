leap(Y) :- Y rem 4 =:= 0, Y rem 100 =\= 0, !.
leap(Y) :- Y rem 400 =:= 0.