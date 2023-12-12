create((X, Y)):-
    X >= 0, X =< 7    % check col
    , Y >= 0, Y =< 7  % and check row
    .

attack((X1, Y1), (X2, Y2)):-
    X1 =:= X2, !         % same col
    ; Y1 =:= Y2, !       % or same row
    ; X2-X1 =:= Y2-Y1, ! % or diagonal top-left bottom-right
    ; X2-X1 =:= Y1-Y2, ! % or diagonal bottom-left top-right
    .
