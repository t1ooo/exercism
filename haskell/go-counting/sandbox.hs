" BW "
" BW "

([ (1, 1) , (1, 2) ], Just Black)
([ (4, 1) , (4, 2) ], Just White) ]




[ "  B  "
, " B B "
, "B W B"
, " W W "
, "  W  " ]



[ (Nothing   , 9)
, (Just Black, 6)
, (Just White, 1) ]



[ "  B  ", " B B ", "B W B", " W W ", "  W  " ]



[ "  B  "
, " B B "
, "B W B"
, " W W "
, "  W  " ]

import Data.List(findIndex)

-- let index = (\(Just x)->x) $ findIndex (\x->x=='B'||x=='W') ("   B   ")


neighbors (x,y) = map (\(dx,dy) -> (x+dx,y+dy)) [(1,0),(-1,0),(0,1),(0,-1)] 
filterNeighbors coords maxX maxY visited = filter (\(x,y)->x>=0 && y>=0 && x<=maxX && y<=maxY && notElem (x,y) visited) $ coords

traverse board (x,y) visited =
    let maxX = (length $ head board) - 1
        maxY = (length board) - 1
        visited' = (x,y):visited
        neighbors' = filterNeighbors (neighbors (x,y)) maxX maxY visited'
    in case board !! y !! x of
        'B' -> []
        'W' -> []
        ' ' -> 
            (x,y) ++
            concatMap (\(x',y')-> traverse board (x',y') visited') neighbors'
        _ -> error "undefined cell"
        