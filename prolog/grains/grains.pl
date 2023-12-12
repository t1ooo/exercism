square(Number, Value) :-
    between(1, 64, Number),
    Value is 2 ^ (Number - 1).

total(Value) :-
    Value is (2 ^ 64) - 1.