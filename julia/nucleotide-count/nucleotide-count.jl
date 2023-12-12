function count_nucleotides(strand)
    counts = Dict('A' => 0, 'C' => 0, 'G' => 0, 'T' => 0)
    for ch in strand
        if !haskey(counts, ch)
            throw(DomainError(strand, "invalid nucleotide $ch'"))
        end
        counts[ch] += 1
    end
    counts
end
