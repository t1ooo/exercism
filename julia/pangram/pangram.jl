function ispangram(input)
    check((lower, upper)) = (lower in input) || (upper in input)
    return all(check, zip('a':'z', 'A':'Z'))
end


function ispangram1(input)
    input = lowercase(input)
    all(c -> c in input, 'a':'z')
end


function ispangram2(input)
    all(c -> (c in input) || (uppercase(c) in input), 'a':'z')
end


function ispangram3(input)
    utf8 = transcode(UInt8, input)
    present = zeros(Bool, 256)
    @inbounds for byte in utf8
        # byte | 0x20 will make uppercase ASCII into lowercase ASCII.
        # Other characters will be mangled, but we don't care about that.
        present[(byte|0x20)+1] = true
    end
    all(present[char+1] for char in UInt8('a'):UInt8('z'))
end


function ispangram4(input)
    alpha = BitSet()
    for ch in input
        if isascii(ch) && isletter(ch)
            push!(alpha, codepoint(lowercase(ch)))
            if length(alpha) == 26
                return true
            end
        end
    end
    return length(alpha) == 26
end
