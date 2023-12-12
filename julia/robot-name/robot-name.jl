import Random: shuffle

L = length('A':'Z') # number of letters
D = length(0:9)     # number of digits

# generate ids instead of full names to reduce memory usage
ids = shuffle(0:L*L*D*D*D-1)

function nameFromId(id)
    id, a = divrem(id, D)
    id, b = divrem(id, D)
    id, c = divrem(id, D)
    id, d = divrem(id, L)
    id, e = divrem(id, L)
    return ('A' + e) * ('A' + d) * string(c) * string(b) * string(a)
end

genName() = nameFromId(pop!(ids))

mutable struct Robot
    name::String
    Robot() = new(genName())
end

function reset!(instance::Robot)
    instance.name = genName()
end

name(instance::Robot) = instance.name
