function secret_handshake(code)
    res = []
    code & 1 == 1 && push!(res, "wink")
    code & 2 == 2 && push!(res, "double blink")
    code & 4 == 4 && push!(res, "close your eyes")
    code & 8 == 8 && push!(res, "jump")
    code & 16 == 16 && reverse!(res)
    res
end
