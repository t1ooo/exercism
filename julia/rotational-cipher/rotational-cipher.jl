function rotate(shift, str::AbstractString)
    map(ch -> rotate(shift, ch), str)
end

function rotate(shift, ch::AbstractChar)
    if isascii(ch) && isletter(ch)
        diff = islowercase(ch) ? 'a' : 'A'
        ch = ((ch - diff + shift) % 26) + diff
    end

    ch
end

for shift = 1:26
    name = Symbol("R", shift, "_str")
    @eval macro $name(str)
        rotate($shift, str)
    end
end
