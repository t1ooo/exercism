-module(rna_transcription).

-export([to_rna/1]).

to_rna(Strand) -> [convert(X) || X <- Strand].

convert($G) -> $C;
convert($C) -> $G;
convert($T) -> $A;
convert($A) -> $U;
convert(_) -> throw(bad_nucleotide).
