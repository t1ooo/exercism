isogram(Str) :-
    upcase_atom(Str, Upcase),
    string_chars(Upcase, Chars),
    include(is_alpha, Chars, Alpha),
    is_uniq(Alpha).

is_uniq(L) :-
    sort(L, Sorted),
    length(L, Len),
    length(Sorted, Len).