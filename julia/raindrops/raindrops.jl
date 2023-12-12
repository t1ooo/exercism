function raindrops(number)
    res = []
    number % 3 == 0 && push!(res, "Pling")
    number % 5 == 0 && push!(res, "Plang")
    number % 7 == 0 && push!(res, "Plong")
    res == [] && push!(res, string(number))
    join(res, "")
end
