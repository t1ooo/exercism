-module(space_age).

-export([age/2]).

-type planet() :: mercury
                | venus
                | earth
                | mars
                | jupiter
                | saturn
                | uranus
                | neptune.

-type second() :: pos_integer().

-spec age(planet(), second()) -> float().
age(mercury, Seconds) -> calc(0.2408467, Seconds);
age(venus, Seconds) -> calc(0.61519726, Seconds);
age(earth, Seconds) -> calc(1.0, Seconds);
age(mars, Seconds) -> calc(1.8808158, Seconds);
age(jupiter, Seconds) -> calc(11.862615, Seconds);
age(saturn, Seconds) -> calc(29.447498, Seconds);
age(uranus, Seconds) -> calc(84.016846, Seconds);
age(neptune, Seconds) -> calc(164.79132, Seconds).

-spec calc(float(), second()) -> float().
calc(Factor, Seconds) -> Seconds / (Factor * 31557600).