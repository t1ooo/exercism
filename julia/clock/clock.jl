import Base: +, -, show
import Printf: @printf
import Dates: Minute

DAY = 24 * 60

struct Clock
    minutes::Int64
end

Clock(hours, minutes) = Clock(mod((hours * 60) + minutes, DAY))

+(clock::Clock, date::Minute) = Clock(0, clock.minutes + date.value)

-(clock::Clock, date::Minute) = clock + (-date)

show(io::IO, clock::Clock) =
    @printf(io, "\"%02d:%02d\"", clock.minutes ÷ 60, clock.minutes % 60)
