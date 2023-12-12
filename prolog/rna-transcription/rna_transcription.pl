rna_transcription(Rna, Dna) :-
    string_chars(Rna, Chars),
    maplist(convert, Chars, DnaChars),
    string_chars(Dna, DnaChars).

convert('G', 'C').
convert('C', 'G').
convert('T', 'A').
convert('A', 'U').
