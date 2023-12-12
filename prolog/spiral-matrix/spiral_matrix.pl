list_fill(Size, Value, ResList) :-
    length(ResList, Size),
    maplist(=(Value), ResList).


matrix_fill(Size, Value, ResMatrix) :-
    length(ResMatrix, Size),
    maplist(list_fill(Size, Value), ResMatrix).


list_replace_by_index(List, Index, NewValue, ResList) :-
    % remove element by index
    nth0(Index, List, _, List2),
    % insert new lement by index
    nth0(Index, ResList, NewValue, List2).


matrix_replace_by_index(Matrix, Index1, Index2, NewValue, ResMatrix) :-
    % find matrix row by index
    nth0(Index1, Matrix, Row),
    % replace row value by index
    list_replace_by_index(Row, Index2, NewValue, RowUpd),
    % remove row by index
    nth0(Index1, Matrix, _, Matrix2),
    % insert updated row by index
    nth0(Index1, ResMatrix, RowUpd, Matrix2).

% ------------------------------------
next(right, X, Y, ResX, ResY) :- ResX is X+1,  ResY is Y.   % move right
next(down , X, Y, ResX, ResY) :- ResX is X  ,  ResY is Y+1. % move down
next(left , X, Y, ResX, ResY) :- ResX is X-1,  ResY is Y.   % move left
next(up   , X, Y, ResX, ResY) :- ResX is X  ,  ResY is Y-1. % move up


fill_element(Direction, (Matrix, X, Y, I), (ResMatrix, ResX, ResY, ResI)) :-
    matrix_replace_by_index(Matrix, Y, X, I, ResMatrix),
    ResI is I + 1,
    next(Direction, X, Y, ResX, ResY).


fill_side_of_square(SideDirections, (Matrix, X, Y, I), Res) :-
    foldl(fill_element, SideDirections, (Matrix, X, Y, I), Res),!.


% fill central cell if size = 1
fill_square(1, (Matrix, X, Y, I), (ResMatrix, ResI)) :-
    matrix_replace_by_index(Matrix, Y, X, I, ResMatrix),
    ResI is I + 1, !.

fill_square(Size, (Matrix, X, Y, I), (ResMatrix, ResI)) :-
    gen_directions(Size, SquareDirection),
    foldl(fill_side_of_square, SquareDirection, (Matrix, X, Y, I), (ResMatrix, _, _, ResI)).


fill_all_squares(Size, Matrix, _, _, _, Matrix) :-
    Size =< 0, !.

fill_all_squares(Size, Matrix, X_Begin, Y_Begin, I, ResMatrix) :-
    fill_square(Size, (Matrix, X_Begin, Y_Begin, I), (Matrix2, I2)),
    Size2 is Size - 2,
    X_Begin2 is X_Begin + 1,
    Y_Begin2 is Y_Begin + 1,
    fill_all_squares(Size2, Matrix2, X_Begin2, Y_Begin2, I2, ResMatrix).

gen_directions(Size, Directions) :-
    Size2 is Size - 1,
    list_fill(Size2, right, Right),
    list_fill(Size2, down, Down),
    list_fill(Size2, left, Left),
    list_fill(Size2, up, Up),
    Directions = [Right,Down,Left,Up].

% ------------------------------------

spiral(0, []) :- !.

spiral(Size, ResMatrix) :-
    matrix_fill(Size, nil, Matrix),
    I = 1,
    X_Begin = 0,
    Y_Begin = 0,
    fill_all_squares(Size, Matrix, X_Begin, Y_Begin, I, ResMatrix).