hamming_distance2(Str1, Str2, Dist) :-
    string_chars(Str1, Chars1),
    string_chars(Str2, Chars2),
    distance(Chars1, Chars2, Dist).

distance([], [], 0).
distance([Char1|Tail1], [Char2|Tail2], Dist) :-
    distance(Tail1, Tail2, Dist2),
    inc_if(Char1 \= Char2, Dist2, Dist).

inc_if(Goal, Val, ResVal) :-
    (Goal -> ResVal is Val + 1; ResVal is Val).