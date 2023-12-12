space_age(Planet, AgeSec, Years) :-
    orbital_period("Earth", OrbitalPeriod),
    factor(Planet, Factor),
    Years is AgeSec / (OrbitalPeriod * Factor).

orbital_period("Earth", 31557600).

factor("Mercury", 0.2408467).
factor("Venus", 0.61519726).
factor("Earth", 1).
factor("Mars", 1.8808158).
factor("Jupiter", 11.862615).
factor("Saturn", 29.447498).
factor("Uranus", 84.016846).
factor("Neptune", 164.79132).