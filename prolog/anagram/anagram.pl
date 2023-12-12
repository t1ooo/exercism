anagram(Word, Options, Matching) :-
    include(is_anagram(Word), Options, R),
    list_to_set(R, Matching).

is_anagram(Word1, Word2) :-
    upcase_atom(Word1, Upcase1),
    upcase_atom(Word2, Upcase2),
    Upcase1 \= Upcase2,
    normalize(Upcase1, R),
    normalize(Upcase2, R).

normalize(Word, SortedChars) :-
    string_chars(Word, Chars),
    msort(Chars, SortedChars).