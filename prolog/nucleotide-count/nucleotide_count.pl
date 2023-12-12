nucleotide_count('', []).
nucleotide_count(DNA, Counts) :-
    string_chars(DNA, Chars),
    foldl(calc_counts, Chars, [0, 0, 0, 0], CountsList),
    convert(CountsList, Counts).

convert([A, C, G, T], [('A', A), ('C', C), ('G', G), ('T', T)]).

key('A', 0).
key('C', 1).
key('G', 2).
key('T', 3).

calc_counts(Char, Counts, ResCounts) :-
    key(Char, Index),
    list_update(Counts, Index, succ, ResCounts).

list_update(List, Index, UpdateFunc, ResList) :-
    nth0(Index, List, RemovedEl, List2),
    call(UpdateFunc, RemovedEl, UpdatedEl),
    nth0(Index, ResList, UpdatedEl, List2).