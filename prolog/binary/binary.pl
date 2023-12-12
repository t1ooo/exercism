binary(Str, Dec) :-
    string_chars(Str, Chars),
    convert(Chars, Dec).

convert([], 0).
convert([Char|T], Res) :-
    char_num(Char, Num),
    length(T, Len),
    convert(T, Res2),
    Res is (Num * 2 ^ Len) + Res2.

char_num('0', 0).
char_num('1', 1).
